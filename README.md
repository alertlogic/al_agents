Alert Logic Agent Cookbook
=================
This cookbook is used to install and configure the Alert Logic agent.

Requirements
------------
The following platforms are tested directly under test kitchen.

- ubuntu-12.04
- centos-6.4
- centos-7.0
- debian-7.8
- fedora-19

#### Cookbook Dependencies
- rsyslog
- line
- selinux_policy

Attributes
----------

* `['al_agent']['agent']['registration_key']` - your required registration key. String defaults to `your_registration_key_here`
* `['al_agent']['agent']['for_autoscaling']` - The for_autoscaling attribute determines if your installation will be configured as a `host` or `role` server.  By default for_autoscaling is set to `false` or in other words as a `host` install.  If autoscaling is set to `true` then the install is configured as a `role` server. Boolean defaults to `false`
* `['al_agent']['agent']['for_imaging']` - The `for_imaging` attribute determines if the install process will continue or stop prior to provisioning.  If the `for_imaging` attribute is set to `true` then the install process perform an install only and stop before provisioning.  This allows for instance snapshots to be saved and started for later use.  With this attribute set to `false` then the provisioning process is performed during setup.  Boolean defaults to `false`
* `['al_agent']['agent']['egress_url']` - By default all traffic is sent to https://vaporator.alertlogic.com:443.  This attribute is useful if you have a machine that is responsible for outbound traffic (NAT box).  If you specify your own URL ensure that it is a properly formatted URI.  String defaults to `https://vaporator.alertlogic.com:443`

Usage
-----
### al_agent::default
The default recipe will attempt to perform an install best suited for your environment.  It will install the package for your system. The default attributes will install the agent in `host` mode (not for image capture).

On linux, the default recipe includes an attempt to detect your logging system and adds a configuration directive for that logging system.  For more information see the al_agent::rsyslog and al_agent::syslog_ng recipes.  This recipe also includes an attempt to detect if selinux is installed on the machine.

On both windows and linux the proper package is installed and the agent is started when the cookbook's defaults are used.

### al_agent::rsyslog
On linux, if you are using rsyslog and desire to skip an attempt at detection, you may run the al_agent::rsyslog recipe independently.  Logging changes are added under the installation's subdirectory in a file named `alertlogic.conf`

### al_agent::syslog_ng
On linux, if you are using syslog-ng and desire to skip an attempt at detection, you may run the al_agent::syslog_ng recipe independently.  Logging changes are added under the installation's subdirectory in a file named `alertlogic.conf`

### al_agent::selinux
On linux, if you are using selinux and desire to skip an attempt at detection, you may run the al_agent::selinux recipe independently. This recipe will add a selinux policy to allow for logging to port 1514.

### al_agent::install
On linux, should you desire to install the package, configure and provision the machine you may run this recipe independently.

### al_agent::start
On linux, this recipe as stated starts the service.


Examples
--------

##### install example
```json
{
  "name":"my_server",
  "run_list": [
    "recipe[al_agent]"
  ]
}
```

##### à la carte recipe example (linux only)
```json
{
  "name":"my_server",
  "run_list": [
    "recipe[al_agent::rsyslog, al_agent::install]"
  ]
}
```


Configurations
--------------
The attributes `for_autoscaling` and `for_imaging` determine your installation type.  They are boolean values and by default both of those values are `false`.  As boolean values, you can create a matrix of four possible configuration outcomes.  It is worth mentioning those configurations.

1. host (default) when `for_autoscaling = false` and `for_imaging = false`
2. host for imaging when `for_autoscaling = false` and `for_imaging = true`
3. role when `for_autoscaling = true` and `for_imaging = false`
4. role for imaging when `for_autoscaling = true` and `for_imaging = true`

Performing an agent install using the cookbook's default attributes, will setup the agent as a `host` type and provision the instance immediately. see *configuration #1* above.  If you have properly set your registration key, your host should appear within Alert Logic's Console within 15 minutes.

Testing
-------

In the root of the project:
* to execute rubocop: `rubocop .`
* to execute foodcritic: `foodcritic .`
* to execute chefspec: `rspec spec`
* to execute test kitchen: `kitchen test`


Troubleshooting
---------------

If the cookbook fails at the provisioning step, one cause is that the agent cannot connect to the egress_url.  Ensure that the proper permissions are configured on the security groups and ACLs to allow for outbound access.  Also check your egress_url attribute and ensure that it is a properly formatted URI.


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
Authors: John Ramos (john.ramos@dualspark.com)
