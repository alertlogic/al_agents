#
# Cookbook Name:: al_agents
# Recipe:: install
#
# Copyright 2015, AlertLogic
#

::Chef::Recipe.send(:include, AlAgents::Helpers)

cache_dir = Chef::Config[:file_cache_path]
cached_package = ::File.join(cache_dir, agent_basename)

remote_file agent_basename do
  extend(AlAgents::Helpers)
  path cached_package
  source node['al_agents']['package']['url']
  action :create_if_missing
end

# let ubuntu know to use dpkg not apt
package agent_basename do
  extend(AlAgents::Helpers)
  source cached_package
  action :install
  version '>=0'
  ignore_failure node['al_agents']['agent']['ignore_failure']
  provider Chef::Provider::Package::Dpkg if node['platform_family'] == 'debian'
  provider Chef::Provider::Package::Rpm if node['platform_family'] == 'rhel' && node['platform_version'].to_i >= 6
end

include_recipe 'al_agents::configure_agent' unless for_imaging
include_recipe 'al_agents::provision_agent' unless for_imaging
