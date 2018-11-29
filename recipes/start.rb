# frozen_string_literal: true

::Chef::Recipe.send(:include, AlAgents::Helpers)
service al_agent_service do
  action :start
end
