directory '/etc/syslog-ng/conf.d' do
  owner 'root'
  group 'root'
  recursive true
  mode '0755'
end

append_if_no_line 'add an include to alertlogic.conf' do
  path '/etc/syslog-ng/syslog-ng.conf'
  line "include '/etc/syslog-ng/conf.d/alertlogic.conf';"
end if syslog_ng_pre33

template '/etc/syslog-ng/conf.d/alertlogic.conf' do
  source 'syslog_ng/alertlogic.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(source_log: node['al_agents']['syslog_ng']['source_log'])
  notifies :restart, 'service[syslog-ng]'
  not_if { ::File.exist?('/etc/syslog-ng/conf.d/alertlogic.conf') }
end

service 'syslog-ng' do
  action [:enable, :start]
end

node.run_state['logging_by'] = 'syslog-ng'
