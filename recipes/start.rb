::Chef::Recipe.send(:include, AlAgents::Helpers)
service service_name do
  action :start
end
