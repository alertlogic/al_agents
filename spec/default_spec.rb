require 'spec_helper'

describe 'al_agent::default' do
  context 'on the linux platform family' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '12.04'
      ).converge(described_recipe)
    end

    it 'includes the linux recipe' do
      expect(chef_run).to include_recipe('al_agent::_linux')
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
      expect(chef_run).to include_recipe('al_agent::_windows')
    end
  end
end
