cache_dir = Chef::Config[:file_cache_path]
basename = agent_file(node['al_agent']['package']['url'])
cached_package = ::File.join(cache_dir, basename)

remote_file basename do
  path cached_package
  source node['al_agent']['package']['url']
  action :create_if_missing
end

# test kitchen issue: the reinstall causes an issue
#   https://github.com/chef/chef/issues/3055s
package basename do
  source cached_package
  action :install
  options windows_options
  not_if windows_install_guard
end

include_recipe 'al_agent::start' unless for_imaging
