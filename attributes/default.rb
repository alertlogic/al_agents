default["alertlogic"]["pkg_base_url"] = "https://scc.alertlogic.net/software"
default["alertlogic"]["firewall"] = [
    # allow destination "network/mask:port"
    "204.110.218.96/27:443",
    "204.110.219.96/27:443"
]
default["alertlogic"]["pkg_vsn"]["deb"] = "LATEST"
default["alertlogic"]["pkg_vsn"]["rpm"] = "LATEST-1"
default["alertlogic"]["controller_host"] = nil
default["alertlogic"]["provision_key"] = nil
