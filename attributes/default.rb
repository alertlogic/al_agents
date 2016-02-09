
# registration key is a must
default['al_agents']['agent']['registration_key'] = 'your_registration_key_here'

default['al_agents']['agent']['egress_url'] = 'https://vaporator.alertlogic.com:443'

default['al_agents']['agent']['proxy_url'] = nil

default['al_agents']['agent']['for_imaging'] = false

default['al_agents']['package']['name'] = 'al-agent'

case node['platform_family']
when 'rhel', 'fedora'
  default['al_agents']['agent']['service_name'] = 'al-agent'
  if node['platform_version'].to_i >= 6
    default['al_agents']['syslog_ng']['source_log'] = 's_all'
  else
    default['al_agents']['syslog_ng']['source_log'] = 's_sys'
  end
  if node['kernel']['machine'] == 'x86_64'
    default['al_agents']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent-LATEST-1.x86_64.rpm'
  else
    default['al_agents']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent-LATEST-1.i386.rpm'
  end
when 'debian'
  default['al_agents']['agent']['service_name'] = 'al-agent'
  default['al_agents']['syslog_ng']['source_log'] = 's_src'
  if node['kernel']['machine'] == 'x86_64'
    default['al_agents']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent_LATEST_amd64.deb'
  else
    default['al_agents']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent_LATEST_i386.deb'
  end
when 'windows'
  default['al_agents']['agent']['service_name'] = 'al_agent'
  default['al_agents']['package']['url'] = 'https://scc.alertlogic.net/software/al_agent-LATEST.msi'
  if node['kernel']['machine'] == 'x86_64'
    default['al_agents']['windows_install_guard'] = 'C:\Program Files (x86)\Common Files\AlertLogic\host_key.pem'
  else
    default['al_agents']['windows_install_guard'] = 'C:\Program Files\Common Files\AlertLogic\host_key.pem'
  end
end
