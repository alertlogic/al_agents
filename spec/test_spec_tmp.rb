
require 'spec_helper'

describe 'al_agent::default' do
  context 'with ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '12.04'
      ).converge(described_recipe)
    end

    it 'calls the Chef::Recipe::Egress method host' do
      allow_any_instance_of(Chef::Recipe::Egress).to receive(:host).and_call_original
      expect_any_instance_of(Chef::Recipe::Egress).to receive(:host)
      chef_run
    end
  end
end
