#
# Cookbook Name:: al_agents
# Recipe:: provision
#
# Copyright 2015, AlertLogic
#

::Chef::Recipe.send(:include, AlAgents::Helpers)

execute "provision #{agent_basename}" do
  extend(AlAgents::Helpers)
  user 'root'
  cwd '/etc/init.d'
  command "./al-agent provision #{provision_options}"
  ignore_failure node['al_agents']['agent']['ignore_failure']
  not_if { ::File.exist?('/var/alertlogic/etc/host_key.pem') }
end
