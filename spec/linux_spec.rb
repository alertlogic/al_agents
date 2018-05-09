
require 'spec_helper'

describe 'al_agents::_linux' do
  context 'with ubuntu (without selinux)' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ).converge(described_recipe)
    end
    let(:package_name) { 'al-agent_LATEST_amd64.deb' }
    let(:remote_file) { "#{Chef::Config[:file_cache_path]}/#{package_name}" }

    before do
      allow_any_instance_of(Chef::Recipe).to receive(:selinux_enabled?).and_return(false)
    end

    it 'downloads al-agent' do
      expect(chef_run).to create_remote_file_if_missing(remote_file.to_s)
    end

    it 'installs al-agent' do
      expect(chef_run).to install_package(package_name.to_s)
    end

    it 'creates a controller_host file? || it executes the configure command' do
      expect(chef_run).to run_execute("configure #{package_name}")
    end

    it 'executes provisioning' do
      expect(chef_run).to run_execute("provision #{package_name}")
    end

    it 'starts al-agent' do
      expect(chef_run).to start_service('al-agent')
    end

    it 'logs data' do
      expect(chef_run).to run_execute('logging')
    end
  end

  context 'with debian' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'centos',
        version: '6.7'
      ).converge(described_recipe)
    end
    let(:package_name) { 'al-agent-LATEST-1.x86_64.rpm' }
    let(:remote_file) { "#{Chef::Config[:file_cache_path]}/#{package_name}" }

    it 'downloads al-agent' do
      expect(chef_run).to create_remote_file_if_missing(remote_file.to_s)
    end

    it 'installs al-agent' do
      expect(chef_run).to install_package(package_name.to_s)
    end

    it 'creates a controller_host file? || it executes the configure command' do
      expect(chef_run).to run_execute("configure #{package_name}")
    end

    it 'executes provisioning' do
      expect(chef_run).to run_execute("provision #{package_name}")
    end

    context 'for_imaging' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'centos',
          version: '6.7'
        ) do |node|
          node.set['al_agents']['agent']['for_imaging'] = true
        end.converge(described_recipe)
      end

      # it 'does not start the service' do
      #   expect(chef_run).to_not start_service('al-agent')
      # end
    end
  end

  context 'with rhel (with selinux)' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'redhat',
        version: '7.3'
      ).converge(described_recipe)
    end

    before do
      allow_any_instance_of(Chef::Recipe).to receive(:selinux_enabled?).and_return(true)
    end
    it 'adds selinux port' do
      expect(chef_run).to addormodify_selinux_policy_port('1514')
    end
  end
end
