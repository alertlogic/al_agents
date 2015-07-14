require 'spec_helper'

describe 'al_agent::syslog_ng' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '12.04'
    ).converge(described_recipe)
  end
  let(:shellout) { double(run_command: nil, error!: nil, stdout: 'syslog-ng 3.2.5', stderr: double(empty?: true)) }
  let(:syslog_ng_conf) { '/etc/syslog-ng/syslog-ng.conf' }
  let(:syslog_ng_dir) { '/etc/syslog-ng/conf.d' }
  let(:alertlogic_conf_file) { "#{syslog_ng_dir}/alertlogic.conf" }

  before do
    # Mixlib::ShellOut.stub(:new).and_return(shellout)
    allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
  end

  it 'creates an alertlogic.conf file' do
    expect(chef_run).to render_file(alertlogic_conf_file)
  end

  it 'ensures the syslog-ng directory exist' do
    expect(chef_run).to create_directory(syslog_ng_dir)
  end

  it 'notifies the syslog_ng service to restart' do
    template = chef_run.template(alertlogic_conf_file)
    expect(template).to notify('service[syslog-ng]').to(:restart)
  end

  it 'starts the service' do
    expect(chef_run).to start_service('syslog-ng')
  end
end
