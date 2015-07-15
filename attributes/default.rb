
# registration key is a must
default['al_agent']['agent']['registration_key'] = 'your_registration_key_here'

default['al_agent']['agent']['egress_url'] = 'https://vaporator.alertlogic.com:443'

default['al_agent']['agent']['for_autoscaling'] = false

default['al_agent']['agent']['for_imaging'] = false

default['al_agent']['package']['name'] = 'al-agent'

case node['platform_family']
when 'rhel', 'fedora'
  default['al_agent']['agent']['service_name'] = 'al-agent'
  default['al_agent']['syslog_ng']['source_log'] = 's_sys'
  if node['kernel']['machine'] == 'x86_64'
    default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent-LATEST-1.x86_64.rpm'
  else
    default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent-LATEST-1.i386.rpm'
  end
when 'debian'
  default['al_agent']['agent']['service_name'] = 'al-agent'
  default['al_agent']['syslog_ng']['source_log'] = 's_src'
  if node['kernel']['machine'] == 'x86_64'
    default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent_LATEST_amd64.deb'
  else
    default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent_LATEST_i386.deb'
  end
when 'windows'
  default['al_agent']['agent']['service_name'] = 'al_agent'
  default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al_agent-LATEST.msi'
  if node['kernel']['machine'] == 'x86_64'
    default['al_agent']['windows_install_guard'] = 'C:\Program Files (x86)\Common Files\AlertLogic\host_key.pem'
  else
    default['al_agent']['windows_install_guard'] = 'C:\Program Files\Common Files\AlertLogic\host_key.pem'
  end
end
