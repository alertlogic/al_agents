::Chef::Recipe.send(:include, AlAgents::Helpers)

include_recipe 'al_agents::selinux' if selinux_enabled?
include_recipe 'al_agents::rsyslog' if rsyslog_detected?
include_recipe 'al_agents::syslog_ng' if syslogng_detected?

include_recipe 'al_agents::install'
include_recipe 'al_agents::start' unless for_imaging
include_recipe 'al_agents::test_log' unless for_imaging
