#
## log-agent
#
default["alertlogic"]["agent"]["pkg_base_url"] = "https://scc.alertlogic.net/software"
default["alertlogic"]["agent"]["pkg_vsn"]["deb"] = "_LATEST_"
default["alertlogic"]["agent"]["pkg_vsn"]["rpm"] = "-LATEST-1."
default["alertlogic"]["agent"]["controller_host"] = nil
default["alertlogic"]["agent"]["inst_type"] = nil
default["alertlogic"]["agent"]["firewall"] = [
    # allow destination "network/mask:port"
    "204.110.218.96/27:443",
    "185.54.124.96/27:443"
]
default["alertlogic"]["agent"]["provision_key"] = nil

#
## log-agent
#
default["alertlogic"]["log-agent"]["pkg_base_url"] = "https://scc.alertlogic.net/software"
default["alertlogic"]["log-agent"]["pkg_vsn"]["deb"] = "_LATEST_"
default["alertlogic"]["log-agent"]["pkg_vsn"]["rpm"] = "-LATEST-1."
default["alertlogic"]["log-agent"]["controller_host"] = nil
default["alertlogic"]["log-agent"]["inst_type"] = nil
default["alertlogic"]["log-agent"]["firewall"] = [
    # allow destination "network/mask:port"
    "204.110.218.96/27:443",
    "185.54.124.96/27:443"
]
default["alertlogic"]["log-agent"]["provision_key"] = nil

#
## threat-host
#
default["alertlogic"]["threat-host"]["pkg_base_url"] = "https://scc.alertlogic.net/software"
default["alertlogic"]["threat-host"]["pkg_vsn"]["deb"] = "_LATEST."
default["alertlogic"]["threat-host"]["pkg_vsn"]["rpm"] = "_LATEST."
default["alertlogic"]["threat-host"]["controller_host"] = nil
default["alertlogic"]["threat-host"]["inst_type"] = nil
default["alertlogic"]["threat-host"]["firewall"] = [
    # allow destination "network/mask:port"
    # unkomment following lines if you need to open outbound connections
    # between threat agent and appliance
    # "<appliance_ip>/32:443",  # agent updates (singe point egress)
    # "<appliance_ip>/32:7777", # agent data transport (between agent and appliance on local network)
    "204.110.218.96/27:443",
    "185.54.124.96/27:443"
]
default["alertlogic"]["threat-host"]["provision_key"] = nil
