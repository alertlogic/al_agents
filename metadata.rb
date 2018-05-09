name 'al_agents'
maintainer 'Justin Early'
maintainer_email 'jearly@alertlogic.com'
source_url 'https://github.com/alertlogic/al_agents' if respond_to?(:source_url)
issues_url 'https://github.com/alertlogic/al_agents/issues' if respond_to?(:issues_url)
license 'Apache-2.0'
description 'Installs/Configures the Alert Logic Agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
chef_version '>= 12.5' if respond_to?(:chef_version)
version '1.4.0'

depends 'selinux_policy'
depends 'rsyslog', '~> 5.1.0'
depends 'line'

supports 'debian'
supports 'ubuntu'
supports 'redhat'
supports 'centos'
supports 'fedora'
supports 'amazon'
supports 'windows'
