#
## log-agent
#
default["alertlogic"]["agent"]["pkg_base_url"] = "https://scc.alertlogic.net/software"
default["alertlogic"]["agent"]["pkg_vsn"]["debian"] = "_LATEST_"
default["alertlogic"]["agent"]["pkg_vsn"]["rhel"] = "-LATEST-1."
default["alertlogic"]["agent"]["pkg_vsn"]["windows"] = "-LATEST"
default["alertlogic"]["agent"]["controller_host"] = nil
default["alertlogic"]["agent"]["inst_type"] = nil
default["alertlogic"]["agent"]["firewall"] = [
    # allow destination "network/mask:port"
    "204.110.218.96/27:443",
    "185.54.124.96/27:443"
]
default["alertlogic"]["agent"]["provision_key"] = nil
default["alertlogic"]["agent"]["use_proxy"] = nil
