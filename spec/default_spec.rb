require 'spec_helper'

describe 'al_agents::default' do
  context 'on ubuntu (without selinux)' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ).converge(described_recipe)
    end

    before do
      allow_any_instance_of(Chef::Recipe).to receive(:selinux_enabled?).and_return(false)
    end

    it 'includes the linux recipe' do
      expect(chef_run).to include_recipe('al_agents::_linux')
    end
  end

  context 'on the windows platform family' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'windows',
        version: '2012'
      ).converge(described_recipe)
    end

    before do
      stub_command('C:\\Program Files (x86)\\Common Files\\AlertLogic\\host_key.pem')\
        .and_return(false)
    end

    it 'includes the windows recipe' do
      expect(chef_run).to include_recipe('al_agents::_windows')
    end
  end
end
