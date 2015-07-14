#
# Cookbook Name:: al_agent
# Recipe:: default
#
# Copyright 2015, AlertLogic
#
# All rights reserved - Do Not Redistribute
#

if platform_family?('windows')
  include_recipe 'al_agent::_windows'
else
  include_recipe 'al_agent::_linux'
end
