require 'spec_helper'

describe 'al_agent::rsyslog' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '12.04'
    ).converge(described_recipe)
  end
  let(:alertlogic_conf_file) { '/etc/rsyslog.d/alertlogic.conf' }

  it 'creates an alertlogic.conf file' do
    expect(chef_run).to render_file(alertlogic_conf_file)
  end

  it 'notifies the rsyslog service to restart' do
    template = chef_run.template(alertlogic_conf_file)
    expect(template).to notify('service[rsyslog]').to(:restart)
  end
end
