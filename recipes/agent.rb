#
# Cookbook Name:: al_agents
# Recipe:: agent
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

pkg_name = "al-agent"

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

## Install, configure, provision
al_agents_pkg pkg_name do
    vsn             node["alertlogic"]["agent"]["pkg_vsn"]
    base_url        node["alertlogic"]["agent"]["pkg_base_url"]
    controller_host node["alertlogic"]["agent"]["controller_host"]
    inst_type       node["alertlogic"]["agent"]["inst_type"]
    provision_key   node["alertlogic"]["agent"]["provision_key"]
    action          :install
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
