al-agents cookbook
=========================

Installs and configures Log and Threat Manager agents.

Log Manager collects and normalizes log data from your entire infrastructure.
Threat Manager’s managed intrusion detection and vulnerability scanning services
provide ongoing insights into the threats and vulnerabilities affecting your
environment.

Requirements
------------

* Os: Ubuntu server 12.04, 13.10 and CentOS 6.5.
* Arch: x86_64, i386.
* System logging: rsyslog, syslog-ng.

Attributes
----------

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['al-agents']['pkg_base_url']</tt></td>
    <td>String</td>
    <td>Package download URL.</td>
    <td><tt>"https://scc.alertlogic.net/software"</tt></td>
  </tr>
  <tr>
    <td><tt>['al-agents']['pkg_vsn']['deb']</tt></td>
    <td>String</td>
    <td>Debian package version to be downloaded.</td>
    <td><tt>"LATEST"</tt></td>
  </tr>
  <tr>
    <td><tt>['al-agents']['pkg_vsn']['rpm']</tt></td>
    <td>String</td>
    <td>Redhat package version to be downloaded.</td>
    <td><tt>"LATEST-1"</tt></td>
  </tr>
  <tr>
    <td><tt>['al-agents']['controller_host']</tt></td>
    <td>String</td>
    <td>Controller host name.</td>
    <td><tt>"vaporator.alertlogic.com"</tt></td>
  </tr>
  <tr>
    <td><tt>['al-agents']['provision_key']</tt></td>
    <td>String</td>
    <td>Unique Registration Key. Used during the provisioning stage.</td>
    <td><tt>nil</tt></td>
  </tr>
</table>

Usage
-----
#### al-agents::default
Installs `al-agents::log-agent`.

#### al-agents::log-agent
`default["alertlogic"]["provision_key"]` must be non empty.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[al-agents::log-agent]"
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
