default["alertlogic"]["log-agent"]["pkg_base_url"] = "https://scc.alertlogic.net/software"
default["alertlogic"]["log-agent"]["pkg_vsn"]["deb"] = "LATEST"
default["alertlogic"]["log-agent"]["pkg_vsn"]["rpm"] = "LATEST-1"
default["alertlogic"]["log-agent"]["controller_host"] = nil
default["alertlogic"]["log-agent"]["inst_type"] = nil
default["alertlogic"]["log-agent"]["firewall"] = [
    # allow destination "network/mask:port"
    "204.110.218.96/27:443",
    "204.110.219.96/27:443"
]
default["alertlogic"]["log-agent"]["provision_key"] = nil
