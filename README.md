# al_agents cookbook


Installs and configures Log and Threat Manager agents.

Log Manager collects and normalizes log data from your entire infrastructure.
Threat Manager’s managed intrusion detection and vulnerability scanning services
provide ongoing insights into the threats and vulnerabilities affecting your
environment.

## Requirements

* Os: Ubuntu server 12.04, 13.10, Debian Squeeze or CentOS 6.5
* Arch: x86_64, i386.
* System logging: rsyslog, syslog-ng.


## Recipes

### al_agents::log_agent

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['al_agents']['log-agent']['pkg_base_url']</tt></td>
    <td>String</td>
    <td>Package download URL.</td>
    <td><tt>"https://scc.alertlogic.net/software"</tt></td>
  </tr>
  <tr>
    <td><tt>['al_agents']['log-agent']['pkg_vsn']['deb']</tt></td>
    <td>String</td>
    <td>Debian package version to be downloaded.</td>
    <td><tt>"_LATEST_"</tt></td>
  </tr>
  <tr>
    <td><tt>['al_agents']['log-agent']['pkg_vsn']['rpm']</tt></td>
    <td>String</td>
    <td>Redhat package version to be downloaded.</td>
    <td><tt>"-LATEST-1."</tt></td>
  </tr>
  <tr>
    <td><tt>['al_agents']['log-agent']['controller_host']</tt></td>
    <td>String or nil</td>
    <td>Controller host name.</td>
    <td><tt>"vaporator.alertlogic.com"</tt></td>
  </tr>
  <tr>
    <td><tt>['al_agents']['log-agent']['inst_type']</tt></td>
    <td>String or nil</td>
    <td>Instance type. May be: "host", "role", nil</td>
    <td><tt>"host"</tt></td>
  </tr>
  <tr>
    <td><tt>['al_agents']['log-agent']['firewall']</tt></td>
    <td>Array</td>
    <td>Array of allowed destination networks</td>
    <td><tt>["204.110.218.96/27:443", "204.110.219.96/27:443"]</tt></td>
  </tr>
  <tr>
    <td><tt>['al_agents']['log-agent']['provision_key']</tt></td>
    <td>String</td>
    <td>Unique Registration Key. Used during the provisioning stage.</td>
    <td><tt>nil</tt></td>
  </tr>
</table>

`default["alertlogic"]["log-agent"]["provision_key"]` must be non empty.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[al_agents::log_agent]"
  ]
}
```


### al_agents::threat_host

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['al_agents']['threat-host']['pkg_base_url']</tt></td>
    <td>String</td>
    <td>Package download URL.</td>
    <td><tt>"https://scc.alertlogic.net/software"</tt></td>
  </tr>
  <tr>
    <td><tt>['al_agents']['threat-host']['pkg_vsn']['deb']</tt></td>
    <td>String</td>
    <td>Debian package version to be downloaded.</td>
    <td><tt>"_LATEST."</tt></td>
  </tr>
  <tr>
    <td><tt>['al_agents']['threat-host']['pkg_vsn']['rpm']</tt></td>
    <td>String</td>
    <td>Redhat package version to be downloaded.</td>
    <td><tt>"_LATEST."</tt></td>
  </tr>
  <tr>
    <td><tt>['al_agents']['threat-host']['controller_host']</tt></td>
    <td>String or nil</td>
    <td>Controller host name.</td>
    <td><tt>"vaporator.alertlogic.com"</tt></td>
  </tr>
  <tr>
    <td><tt>['al_agents']['threat-host']['inst_type']</tt></td>
    <td>String or nil</td>
    <td>Instance type. May be: "host", "role", nil</td>
    <td><tt>"host"</tt></td>
  </tr>
  <tr>
    <td><tt>['al_agents']['threat-host']['firewall']</tt></td>
    <td>Array</td>
    <td>Array of allowed destination networks</td>
    <td><tt>["204.110.218.96/27:443", "204.110.219.96/27:443"]</tt></td>
  </tr>
  <tr>
    <td><tt>['al_agents']['threat-host']['provision_key']</tt></td>
    <td>String</td>
    <td>Unique Registration Key. Used during the provisioning stage.</td>
    <td><tt>nil</tt></td>
  </tr>
</table>

`default["alertlogic"]["threat-host"]["provision_key"]` must be non empty.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[al_agents::threat_host]"
  ]
}
```


Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Distributed under the Apache 2.0 license.

Authors:
* Churikov Daniil <dchurikov@alertlogic.com>
