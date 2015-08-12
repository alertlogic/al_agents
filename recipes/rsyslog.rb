::Chef::Recipe.send(:include, AlAgents::Helpers)

config_prefix = node['rsyslog']['config_prefix']
template "#{config_prefix}/rsyslog.d/alertlogic.conf" do
  source 'rsyslog/alertlogic.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
  not_if { ::File.exist?("#{node['rsyslog']['config_prefix']}/rsyslog.d/alertlogic.conf") }
end

extend RsyslogCookbook::Helpers
declare_rsyslog_service

node.run_state['logging_by'] = 'rsyslog'
