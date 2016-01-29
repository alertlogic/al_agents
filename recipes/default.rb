#
# Cookbook Name:: al_agents
# Recipe:: default
#
# Copyright 2015, AlertLogic
#

if platform_family?('windows')
  include_recipe 'al_agents::_windows'
else
  include_recipe 'al_agents::_linux'
end
