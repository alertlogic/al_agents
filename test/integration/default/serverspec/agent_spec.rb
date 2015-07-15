require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'agent installation' do
  # it 'is listening on port 1514' do
  #   expect(port(1514)).to be_listening
  # end

  it 'has a running service of al-agent' do
    expect(service('al-agent')).to be_running
  end
end

describe file('/var/alertlogic/lib/agent/etc/controller_host') do
  it { should be_file }
end

# http://serverspec.org/resource_types.html#iptables
# log "**** configure_iptables? ****"
# #{node['al_agent']['configure_iptable']}
# describe 'iptable changes' do
#   describe iptables do
#     # it { should have_rule('-P INPUT ACCEPT') }
#     # -A OUTPUT -m tcp -p tcp -d #{destination} --dport #{port} -j ACCEPT
#     it { should have_rule("-A OUTPUT ACCEPT") }
#   end
# end
#
# # http://serverspec.org/resource_types.html#selinux
# describe 'seliux changes' do
#   describe selinux do
#     it { should be_disabled }
#   end
# end
