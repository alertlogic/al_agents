#
# Cookbook Name:: al_agents
# Recipe:: configure
#
# Copyright 2015, AlertLogic
#

::Chef::Recipe.send(:include, AlAgents::Helpers)

execute "configure #{agent_basename}" do
  extend(AlAgents::Helpers)
  user 'root'
  cwd '/etc/init.d'
  command "./al-agent configure #{configure_options}"
end
