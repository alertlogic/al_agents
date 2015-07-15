require 'chefspec'
require 'chefspec/berkshelf'
require 'fauxhai'

require_relative '../libraries/egress.rb'

# bug in chef-12.3.0/lib/chef/resource/windows_package.rb for testing windows on a linux platform
# https://github.com/opscode-cookbooks/windows/issues/158
::File::ALT_SEPARATOR = '/'

ChefSpec::Coverage.start! do
  add_filter do |resource|
    resource.name =~ /log:/
  end
end
