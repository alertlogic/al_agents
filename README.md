# al_agents cookbook

Installs and configures Log and Threat Manager agents.

Log Manager collects and normalizes log data from your entire infrastructure.
Threat Manager’s managed intrusion detection and vulnerability scanning services
provide ongoing insights into the threats and vulnerabilities affecting your
environment.

[![Build Status](https://travis-ci.org/alertlogic/al_agents.svg)](http://travis-ci.org/alertlogic/al_agents)

1. [Requirements](#requirements)
2. [Chef recipes](#recipes)
3. [CloudInit](#cloudinit)
4. [Contributing](#contributing)
5. [License](#license)

## Requirements

* Os: Ubuntu server 12.04, 13.10, Debian Squeeze or CentOS 6.5
* Arch: x86_64, i386.
* System logging: rsyslog, syslog-ng.


## Recipes

### al_agents::agent
All the attributes are accessible under `node['alertlogic']['agent']`
section.

| Key                   | Description          | Default                               |
| --------------------- | -------------------- | ------------------------------------- |
| `['pkg_base_url']`    | Package download URL | "https://scc.alertlogic.net/software" |
| `['pkg_vsn']['deb']`  | Debian package version to be downloaded | `"_LATEST_"`       |
| `['pkg_vsn']['rpm']`  | Redhat package version to be downloaded | `"-LATEST-1."`     |
| `['controller_host']` | Controller host name | `"vaporator.alertlogic.com"`          |
| `['inst_type']`       | Instance type. May be: "host", "role"   | `"host"`           |
| `['firewall']`        | Array of allowed destination networks   | `["204.110.218.96/27:443", "185.54.124.96/27:443"]` |
| `['provision_key']`   | Unique Registration Key, used during the provisioning stage **Must not be nil** | `nil` |


Example:
```json
{
  "alertlogic": {
      "agent": {
          "provision_key": "0123456789abcdefghijklmnopqrstuvwxyz0123456789abcd"
      }
  },
  "run_list": [
    "recipe[al_agents::agent]"
  ]
}
```

### al_agents::log_agent (DEPRECATED)
All the attributes are accessible under `node['alertlogic']['log-agent']`
section.

| Key                   | Description          | Default                               |
| --------------------- | -------------------- | ------------------------------------- |
| `['pkg_base_url']`    | Package download URL | "https://scc.alertlogic.net/software" |
| `['pkg_vsn']['deb']`  | Debian package version to be downloaded | `"_LATEST_"`       |
| `['pkg_vsn']['rpm']`  | Redhat package version to be downloaded | `"-LATEST-1."`     |
| `['controller_host']` | Controller host name | `"vaporator.alertlogic.com"`          |
| `['inst_type']`       | Instance type. May be: "host", "role"   | `"host"`           |
| `['firewall']`        | Array of allowed destination networks   | `["204.110.218.96/27:443", "185.54.124.96/27:443"]` |
| `['provision_key']`   | Unique Registration Key, used during the provisioning stage **Must not be nil** | `nil` |


Example:
```json
{
  "alertlogic": {
      "log-agent": {
          "provision_key": "0123456789abcdefghijklmnopqrstuvwxyz0123456789abcd"
      }
  },
  "run_list": [
    "recipe[al_agents::log_agent]"
  ]
}
```

### al_agents::threat_host (DEPRECATED)
All the attributes are accessible under `node['alertlogic']['threat-host']`
section.

| Key                   | Description          | Default                               |
| --------------------- | -------------------- | ------------------------------------- |
| `['pkg_base_url']`    | Package download URL | "https://scc.alertlogic.net/software" |
| `['pkg_vsn']['deb']`  | Debian package version to be downloaded | `"_LATEST."`       |
| `['pkg_vsn']['rpm']`  | Redhat package version to be downloaded | `"_LATEST."`     |
| `['controller_host']` | Controller host name | `"vaporator.alertlogic.com"`          |
| `['inst_type']`       | Instance type. May be: "host", "role"   | `"host"`           |
| `['firewall']`        | Array of allowed destination networks   | `["204.110.218.96/27:443", "185.54.124.96/27:443"]` |
| `['provision_key']`   | Unique Registration Key, used during the provisioning stage **Must not be nil** | `nil` |


Example:
```json
{
  "alertlogic": {
      "threat-host": {
          "provision_key": "0123456789abcdefghijklmnopqrstuvwxyz0123456789abcd"
      }
  },
  "run_list": [
    "recipe[al_agents::threat_host]"
  ]
}
```

## CloudInit
[CloudInit](http://cloudinit.readthedocs.org/) is the way to install something
onto cloud instances (i.e. amazon ec2).
You may find useful examples under [cloud-init](cloud-init/) directory.
In case of amazon ec2 just pass this .yml file as `user-data`, do not forget
to change `provision_key`.
This will install chef-client to your instance, download this cookbook and
run `chef-solo`.

Note that in case of amazon ec2 `user-data` will be accessible to any
user from within this instance.


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request to `master` branch using Github

## License

Distributed under the Apache 2.0 license.

### Authors:
* Churikov Daniil <dchurikov@alertlogic.com>
