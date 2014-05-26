#
# Cookbook Name:: al-agents
# Recipe:: log-agent
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

pkg_base_url    = node["alertlogic"]["pkg_base_url"]
controller_host = node["alertlogic"]["controller_host"]
provision_key   = node["alertlogic"]["provision_key"]
firewall_rules  = node["alertlogic"]["firewall"]

pkg_name        = "al-log-agent" 

node_arch = node["kernel"]["machine"]

if platform_family?("debian")
    pkg_vsn = node["alertlogic"]["pkg_vsn"]["deb"]
    pkg_full_name =
        if node_arch == "x86_64"
            "al-log-agent_#{pkg_vsn}_amd64.deb"
        elsif node_arch == "i386"
            "al-log-agent_#{pkg_vsn}_i386.deb"
        else
            raise "Unsupported architecture: #{node_arch}"
        end
    pkg_provider = Chef::Provider::Package::Dpkg
    pkg_check_cmd = "dpkg-query -W '#{pkg_name}'"
    semanage_pkg   = "policycoreutils"
elsif platform_family?("rhel")
    pkg_vsn = node["alertlogic"]["pkg_vsn"]["rpm"]
    pkg_full_name =
        if node_arch == "x86_64"
            "al-log-agent-#{pkg_vsn}.x86_64.rpm"
        elsif node_arch == "i386"
            "al-log-agent-#{pkg_vsn}.i386.rpm"
        else
            raise "Unsupported architecture: #{node_arch}"
        end
    pkg_provider = Chef::Provider::Package::Rpm
    pkg_check_cmd = "rpm -qa | grep -q '#{pkg_name}'"
    semanage_pkg   = "policycoreutils-python"
else
    raise "Unsupported platform: #{node[:platform]}"
end

## Install
pkg_tmp = "/tmp/#{pkg_full_name}"

remote_file pkg_tmp do
    source              "#{pkg_base_url}/#{pkg_full_name}"
    use_last_modified   false
    not_if              pkg_check_cmd
end

package pkg_tmp do
    provider pkg_provider
    action   :install
    only_if  do ::File.exists?(pkg_tmp) end
end


## SeLinux
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

if firewall_rules.any?
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

controller_host_code =
    if controller_host 
        "--host #{controller_host}"
    else
        ""
    end
bash "al-log-agent configure" do
    user "root"
    code "/etc/init.d/#{pkg_name} configure #{controller_host_code}"
    not_if "test -f /var/alertlogic/lib/log-agent/etc/controller_host"
end

bash "al-log-agent provision" do
    user "root"
    code "/etc/init.d/#{pkg_name} provision --key #{provision_key}"
    not_if "test -f /var/alertlogic/etc/host_key.pem"
end

## TODO: autostart
bash "al-log-agent start" do
    user "root"
    code "/etc/init.d/#{pkg_name} start"
    not_if "/etc/init.d/#{pkg_name} status"
end

## Syslog
## TODO: syslog-ng, systemd
bash "update /etc/rsyslog.conf and restart rsyslog" do
    user "root"
        code <<-EOH
            echo "*.* @@127.0.0.1:1514;RSYSLOG_FileFormat" >> /etc/rsyslog.conf
            service rsyslog restart
        EOH
    not_if 'grep -q "*.* @@127.0.0.1:1514;RSYSLOG_FileFormat" /etc/rsyslog.conf' 
end
