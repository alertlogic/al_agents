#
# Cookbook Name:: al_agents
# Recipe:: linux_agent
#
# Copyright (c) 2014, Alert Logic.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

## SeLinux
semanage_pkg =
    if platform_family?("debian")
        "policycoreutils"
    elsif platform_family?("rhel")
        "policycoreutils-python"
    else
        raise "Unsupported platform"
    end

package semanage_pkg do
    action :install
end

bash "update selinux" do
    code 'semanage port -a -t syslogd_port_t -p tcp 1514'
    only_if 'sestatus | grep -q "SELinux status:\s*enabled" \
             && sestatus | grep -q "Current mode:\s*enforcing" \
             && ( semanage port -l | grep "syslogd_port_t\s*tcp.*\<1514\>" \
                  && exit 1 || exit 0 ) #swap status code'
end

## Firewall
## TODO: not persistent

firewall_rules = node["alertlogic"]["agent"]["firewall"]
if !firewall_rules.nil?
    firewall_cmd =
        firewall_rules.map { |r|
            (fw_net, fw_port) = r.split(":")
                "iptables -A OUTPUT -m tcp -p tcp -d #{fw_net}" \
                          " --dport #{fw_port} -j ACCEPT"
            }.join("; ")

    firewall_check_cmd =
        firewall_rules.map { |r|
            (fw_net, fw_port) = r.split(":")
            "iptables -L | grep -q #{fw_net}"
        }.join(" || ")

    bash "update iptables OUTPUT chain" do
        code    firewall_cmd
        not_if  firewall_check_cmd
    end
end


#build remote_file source URL
pkg_base_url = node["alertlogic"]["agent"]["pkg_base_url"]
pkg_vsn = node["alertlogic"]["agent"]["pkg_vsn"]["#{node[:platform_family]}"]
pkg_ext = node["alertlogic"]["agent"]["pkg_ext"]
pkg_name = "al-agent"
source = "#{pkg_base_url}/#{pkg_name}#{pkg_vsn}#{node[:kernel][:machine]}#{pkg_ext}"

#define where the package will be located on local file system
alertlogic_package = "#{Chef::Config[:file_cache_path]}/#{pkg_name}-#{pkg_vsn}#{node[:kernel][:machine]}#{pkg_ext}"

#download package
remote_file alertlogic_package do
  source source
end

#install package
package alertlogic_package do
  only_if { ::File.exists?("#{alertlogic_package}") }  
end



#define options for agent configuration
controller_host = node["alertlogic"]["agent"]["controller_host"]
inst_type = node["alertlogic"]["agent"]["inst_type"]
prov_key = node["alertlogic"]["agent"]["provision_key"]

#configure agent
bash "#{pkg_name} configure" do
    user "root"
    if controller_host == nil
        code "/etc/init.d/#{pkg_name} configure"
        not_if "test -f /var/alertlogic/lib/#{pkg_name.sub(%r{^al-}, "")}/etc/controller_host"
    else
        code "/etc/init.d/#{pkg_name} configure --host #{controller_host}"
        not_if "test -f /var/alertlogic/lib/#{pkg_name.sub(%r{^al-}, "")}/etc/controller_host"
    end
end

#provision agent
bash "#{pkg_name} provision" do
    user "root"
    if inst_type == nil
        code "/etc/init.d/#{pkg_name} provision --key #{prov_key}"
        not_if "test -f /var/alertlogic/etc/host_key.pem"
    else
        code "/etc/init.d/#{pkg_name} provision --key #{prov_key} --inst-type #{inst_type}"
        not_if "test -f /var/alertlogic/etc/host_key.pem"
    end
end

#start agent
service pkg_name do
    action :start
end

bash "update /etc/rsyslog.conf and restart rsyslog" do
    user "root"
        code <<-EOH
            echo "*.* @@127.0.0.1:1514;RSYSLOG_FileFormat" >> /etc/rsyslog.conf
            # return 0 in case of restart
            ps -e | grep -q rsyslog && service rsyslog restart || echo "rsyslog not running"
        EOH
    only_if do ::File.exist?('/etc/rsyslog.conf') end
    not_if 'grep -q "*.* @@127.0.0.1:1514;RSYSLOG_FileFormat" /etc/rsyslog.conf'
end

bash "update /etc/syslog-ng/syslog-ng.conf and restart syslog-ng" do
    user "root"
        code <<-EOH
            CONF=/etc/syslog-ng/syslog-ng.conf

            # detect default source name
            DEFSRC=$( cat $CONF | grep -e '^source .* {$' | sed 's/^source \\(.*\\) {$/\\1/g' )

            echo 'destination d_alertlogic {tcp("localhost" port(1514));};' >> $CONF
            echo 'log { source('$DEFSRC'); destination(d_alertlogic); };' >> $CONF
            ps -e | grep -q syslog-ng && service syslog-ng restart || echo "syslog-ng not running"
        EOH
    only_if do ::File.exist?('/etc/syslog-ng/syslog-ng.conf') end
    not_if 'grep -q "alertlogic" /etc/syslog-ng/syslog-ng.conf'
end
