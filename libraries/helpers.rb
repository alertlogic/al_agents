# bring in the selinux_enabled? method
Chef::Recipe.send(:include, Chef::Util::Selinux)

module AlAgents
  # Al Agents Helpers
  module Helpers
    def al_agent
      node['al_agents']['package']['name']
    end

    def agent_file(uri)
      require 'pathname'
      require 'uri'
      Pathname.new(URI.parse(uri).path).basename.to_s
    end

    def agent_basename
      agent_file(node['al_agents']['package']['url'])
    end

    def al_agent_service
      node['al_agents']['agent']['al_agent_service']
    end

    def windows_install_guard
      node['al_agents']['windows_install_guard']
    end

    def registration_key
      node['al_agents']['agent']['registration_key']
    end

    # for_imaging: configure ~> run just the configure commands, provision ~> run the provision command
    def for_imaging
      node['al_agents']['agent']['for_imaging']
    end

    def rsyslog_detected?
      file_path = "#{node['rsyslog']['config_prefix']}/rsyslog.conf"
      ::File.exist?(file_path)
    end

    def syslogng_detected?
      ::File.exist?('/etc/syslog-ng/syslog-ng.conf')
    end

    def syslog_ng_pre33
      vers = Mixlib::ShellOut.new('syslog-ng -V')
      vers.run_command
      syslog_ng_version(vers.stdout) <= 3.2 ? true : false
    end

    def syslog_ng_version(t)
      version = t.split(/\n/)[0]
      version_value = version.split[1].to_f
      version_value
    end

    def proxy_url
      node['al_agents']['agent']['proxy_url']
    end

    def configure_options
      egress = Chef::Recipe::Egress.new(node)
      options = []
      options << "--proxy #{proxy_url}" unless proxy_url.nil?
      options << "--host #{egress.host} --port #{egress.port}"
      options.join(' ')
    end

    def provision_options
      options = []
      options << "--key #{registration_key}"
      options << '--inst-type host'
      options.join(' ')
    end

    def windows_options
      egress = Chef::Recipe::Egress.new(node)
      windows_options = ["/quiet prov_key=#{registration_key}"]
      windows_options << 'prov_only=host' unless for_imaging == false
      windows_options << "USE_PROXY=#{proxy_url}" unless proxy_url.nil?
      windows_options << 'install_only=1' if for_imaging
      windows_options << "sensor_host=#{egress.sensor_host}"
      windows_options << "sensor_port=#{egress.sensor_port}"
      windows_options.join(' ')
    end
  end
end
