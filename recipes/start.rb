# ::Chef::Recipe.send(:include, AlAgents::Helpers)
# dont include Helpers here and see if it works

# service service_name do
#   action :start
# end

include_recipe 'mysql::server'
