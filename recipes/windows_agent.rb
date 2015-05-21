#
# Cookbook Name:: al_agents
# Recipe:: windows_agent
#
# Copyright (c) 2015, Alert Logic.
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

#build remote_file source URL
pkg_base_url = node["alertlogic"]["agent"]["pkg_base_url"]
pkg_ext = node["alertlogic"]["agent"]["pkg_ext"]
pkg_vsn = node["alertlogic"]["agent"]["pkg_vsn"]["#{pkg_ext}"]
pkg_name = "al_agent"
source = "#{pkg_base_url}/#{pkg_name}#{pkg_vsn}.#{pkg_ext}"

#define where the package will be located on local file system
local_source = "#{Chef::Config[:file_cache_path]}/#{pkg_name}#{pkg_vsn}.#{pkg_ext}"

#download package
remote_file local_source do
  source source
end

#define options for package installation
sensor_host = node["alertlogic"]["agent"]["controller_host"]
sensor_port = node["alertlogic"]["agent"]["sensor_port"]
use_proxy = node["alertlogic"]["agent"]["use_proxy"]
prov_key = node["alertlogic"]["agent"]["provision_key"]
options = "SENSOR_HOST=#{sensor_host} SENSOR_PORT=#{sensor_port} USE_PROXY=#{use_proxy} PROV_KEY=#{prov_key}"

#install package
package pkg_name do
  provider pkg_provider
  source local_source
  options options
  only_if { ::File.exists?("#{local_source}") }
end
