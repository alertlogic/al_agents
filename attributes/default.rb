#
## al-agent
#
default["alertlogic"]["agent"]["pkg_base_url"] = "https://scc.alertlogic.net/software"
default["alertlogic"]["agent"]["pkg_vsn"]["deb"] = "_LATEST_"
default["alertlogic"]["agent"]["pkg_vsn"]["rpm"] = "-LATEST-1."
default["alertlogic"]["agent"]["controller_host"] = "vaporator.alertlogic.com"
default["alertlogic"]["agent"]["inst_type"] = "host"
default["alertlogic"]["agent"]["firewall"] = [
    # allow destination "network/mask:port"
    "204.110.218.96/27:443",
    "185.54.124.96/27:443"
]
default["alertlogic"]["agent"]["provision_key"] = nil
