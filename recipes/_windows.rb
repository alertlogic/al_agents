::Chef::Recipe.send(:include, AlAgents::Helpers)

cache_dir = Chef::Config[:file_cache_path]
cached_package = ::File.join(cache_dir, agent_basename)

remote_file agent_basename do
  extend(AlAgents::Helpers)
  path cached_package
  source node['al_agents']['package']['url']
  action :create_if_missing
end

# test kitchen issue: the reinstall causes an issue
#   https://github.com/chef/chef/issues/3055s
package agent_basename do
  extend(AlAgents::Helpers)
  source cached_package
  action :install
  options windows_options
  not_if { ::File.exist?(windows_install_guard) }
end

include_recipe 'al_agents::start' unless for_imaging
