#
# Cookbook Name:: al_agents
# Recipe:: default
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

#include platform appropriate recipe
case node[:platform_family]
when "debian"
  if node[:kernel][:machine] == "x86_64"
    node.default["alertlogic"]["agent"]["pkg_ext"] = "amd64.deb"
  elsif ["i386", "i568", "i686"].include? node[:kernel][:machine]
    node.default["alertlogic"]["agent"]["pkg_ext"] = "i386.deb"
  else Chef::Application.Fatal.!("This cookbook does not support #{node[:platform_family]} machine architecture #{node[:kernel][:machine]}")
  end
  include_recipe "al_agents::linux_agent"
when "rhel"
  if node[:kernel][:machine] == "x86_64"
    node.default["alertlogic"]["agent"]["pkg_ext"] = "x86_64.rpm"
  elsif ["i386", "i568", "i686"].include? node[:kernel][:machine]
    node.default["alertlogic"]["agent"]["pkg_ext"] = "i386.rpm"
  else Chef::Application.Fatal.!("This cookbook does not support #{node[:platform_family]} machine architecture #{node[:kernel][:machine]}")
  end
  include_recipe "al_agents::linux_agent"
when "windows"
  node.default["alertlogic"]["agent"]["pkg_ext"] = "msi"
  include_recipe "al_agents::windows_agent"
else Chef::Application.fatal.!("This cookbook does not support #{node[:platform]}.")
end
