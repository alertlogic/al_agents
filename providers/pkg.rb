action :install do
    pkg_name = new_resource.name

    if platform_family?("debian")
        pkg_full_name =
            if node.kernel.machine == "x86_64"
                "#{pkg_name}#{new_resource.vsn["deb"]}amd64.deb"
            elsif ["i386", "i568", "i686"].include? node.kernel.machine
                "#{pkg_name}#{new_resource.vsn["deb"]}i386.deb"
            else
                raise "Unsupported platform"
            end
        pkg_provider = Chef::Provider::Package::Dpkg
        pkg_check_cmd = "dpkg-query -W '#{pkg_name}'"
    elsif platform_family?("rhel")
        pkg_full_name =
            if node.kernel.machine == "x86_64"
                "#{pkg_name}#{new_resource.vsn["rpm"]}x86_64.rpm"
            elsif ["i386", "i568", "i686"].include? node.kernel.machine
                "#{pkg_name}#{new_resource.vsn["rpm"]}i386.rpm"
            else
                raise "Unsupported platform"
            end
        pkg_provider = Chef::Provider::Package::Rpm
        pkg_check_cmd = "rpm -qa | grep -q '#{pkg_name}'"
    else
        raise "Unsupported platform"
    end

    pkg_tmp = "/tmp/#{pkg_full_name}"

    remote_file pkg_tmp do
        source              "#{new_resource.base_url}/#{pkg_full_name}"
        use_last_modified   false
        not_if              pkg_check_cmd
    end

    package pkg_tmp do
        provider pkg_provider
        action   :install
        only_if  do ::File.exists?(pkg_tmp) end
    end

    controller_host_code =
        if new_resource.controller_host 
            "--host #{new_resource.controller_host}"
        else
            ""
        end

    bash "#{pkg_name} configure" do
        user "root"
        code "/etc/init.d/#{pkg_name} configure #{controller_host_code}"
        not_if "test -f /var/alertlogic/lib/#{pkg_name.sub(%r{^al-}, "")}/etc/controller_host"
    end

    inst_type_code =
        if new_resource.inst_type
            "--inst-type #{new_resource.inst_type}"
        else
            ""
        end
    bash "#{pkg_name} provision" do
        user "root"
        code "/etc/init.d/#{pkg_name} provision --key #{new_resource.provision_key} #{inst_type_code}"
        not_if "test -f /var/alertlogic/etc/host_key.pem"
    end
    
    bash "#{pkg_name} start" do
        user "root"
        code "/etc/init.d/#{pkg_name} start"
        not_if "/etc/init.d/#{pkg_name} status"
    end
end
