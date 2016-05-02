#
# Cookbook Name:: al_agents
# Recipe:: selinux
#
# Copyright 2015, AlertLogic
#

include_recipe 'selinux_policy::install'
selinux_policy_port '1514' do
  port 1514
  protocol 'tcp'
  secontext 'syslogd_port_t'
end
