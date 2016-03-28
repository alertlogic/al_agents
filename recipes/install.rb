#
# Cookbook Name:: al_agents
# Recipe:: install
#
# Copyright 2015, AlertLogic
#

::Chef::Recipe.send(:include, AlAgents::Helpers)
::Chef::Resource.send(:include, AlAgents::Helpers)

cache_dir = Chef::Config[:file_cache_path]
cached_package = ::File.join(cache_dir, basename)

remote_file basename do
  path cached_package
  source node['al_agents']['package']['url']
  action :create_if_missing
end

# let ubuntu know to use dpkg not apt
package basename do
  source cached_package
  action :install
  version '>=0'
  provider Chef::Provider::Package::Dpkg if node['platform_family'] == 'debian'
  provider Chef::Provider::Package::Rpm if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 6
end

include_recipe 'al_agents::configure_agent' unless for_imaging
include_recipe 'al_agents::provision_agent' unless for_imaging
