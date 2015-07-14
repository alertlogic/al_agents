
execute 'logging' do
  command "logger -p mail.info testing from #{node['hostname']} by #{node.run_state['logging_by']}"
end
