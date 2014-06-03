#
# Cookbook Name:: al_agents
# Recipe:: threat_host
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

pkg_name = "al-threat-host" 

## Firewall
## TODO: not persistent

firewall_rules = node["alertlogic"]["threat-host"]["firewall"]
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
    vsn             node["alertlogic"]["threat-host"]["pkg_vsn"]
    base_url        node["alertlogic"]["threat-host"]["pkg_base_url"]
    controller_host node["alertlogic"]["threat-host"]["controller_host"]
    inst_type       node["alertlogic"]["threat-host"]["inst_type"]
    provision_key   node["alertlogic"]["threat-host"]["provision_key"]
    action          :install
end
