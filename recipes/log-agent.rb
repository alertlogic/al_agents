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

## Firewall
## TODO: not persistent
bash "update iptables OUTPUT chain" do
    code <<-EOH
        iptables -A OUTPUT -m tcp -p tcp -d 204.110.218.96/27 --dport 443 -j ACCEPT
        iptables -A OUTPUT -m tcp -p tcp -d 204.110.219.96/27 --dport 443 -j ACCEPT
    EOH
    not_if "iptables -L | grep -q 204\.110\.21[89]\."
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
