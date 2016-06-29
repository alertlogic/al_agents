[![Build Status](https://api.travis-ci.org/alertlogic/al_agents.svg?branch=master)](https://travis-ci.org/alertlogic/al_agents)


Alert Logic Agent Cookbook
=================
This cookbook is used to install and configure the Alert Logic agent.

Requirements
------------
The following platforms are tested directly under test kitchen.

- ubuntu-12.04
- ubuntu-14.04
- centos-6.4
- centos-7.0
- debian-7.8
- fedora-19
- windows-2012r2

#### Cookbook Dependencies
- rsyslog
- line
- selinux_policy

Attributes
----------

* `['al_agents']['agent']['registration_key']` - your required registration key. String defaults to `your_registration_key_here`
* `['al_agents']['agent']['for_imaging']` - The `for_imaging` attribute determines if the agent will be configured and provisioned.  If the `for_imaging` attribute is set to `true` then the install process performs an installation of the agent but will not start the agent once installation is completed.  This allows for instance snapshots to be saved and started for later use.  With this attribute set to `false` then the provisioning process is performed during setup and the agent is started once complete.  Boolean defaults to `false`
* `['al_agents']['agent']['egress_url']` - By default all traffic is sent to https://vaporator.alertlogic.com.  This attribute is useful if you have a machine that is responsible for outbound traffic (NAT box).  If you specify your own URL ensure that it is a properly formatted URI.  String defaults to `https://vaporator.alertlogic.com`
* `['al_agents']['agent']['proxy_url']` - By default al-agent does not require the use of a proxy.  This attribute is useful if you want to avoid a single point of egress.  When a proxy is used, both `['al_agents']['agent']['egress_url']` and `['al_agents']['agent']['proxy_url']` values are required.  If you specify a proxy URL ensure that it is a properly formatted URI.  String defaults to `nil`
* `['al_agents']['agent']['ignore_failure']` - Ingore installation and configuration errors. Boolean defaults to `false`


Usage
-----
### al_agents::default
The default recipe will attempt to perform an install best suited for your environment.  It will install the package for your system. The default attributes will install the agent in `host` mode (not for image capture).

On linux, the default recipe includes an attempt to detect your logging system and adds a configuration directive for that logging system.  For more information see the al_agents::rsyslog and al_agents::syslog_ng recipes.  This recipe also includes an attempt to detect if selinux is installed on the machine.

On both windows and linux the proper package is installed and the agent is started when the cookbook's defaults are used.

### al_agents::rsyslog
On linux, if you are using rsyslog and desire to skip an attempt at detection, you may run the al_agent::rsyslog recipe independently.  Logging changes are added under the installation's subdirectory in a file named `alertlogic.conf`

### al_agents::syslog_ng
On linux, if you are using syslog-ng and desire to skip an attempt at detection, you may run the al_agents::syslog_ng recipe independently.  Logging changes are added under the installation's subdirectory in a file named `alertlogic.conf`

### al_agents::selinux
On linux, if you are using selinux and desire to skip an attempt at detection, you may run the al_agents::selinux recipe independently. This recipe will add a selinux policy to allow for logging to port 1514.  This recipe does not enable nor disable selinux policy enforcement.

### al_agents::install
On linux, should you desire to install the package, configure and provision the machine you may run this recipe independently.

### al_agents::start
On linux, this recipe as stated starts the service.


Examples
--------

##### install example
```json
{
  "name":"my_server",
  "run_list": [
    "recipe[al_agents]"
  ]
}
```

##### à la carte recipe example (linux only)
```json
{
  "name":"my_server",
  "run_list": [
    "recipe[al_agents::rsyslog, al_agents::install]"
  ]
}
```


Configurations
--------------
The attribute `for_imaging` determine your installation type.  It is a boolean value and by default is `false`.  Setting this value to true will prepare your agent for imaging only and will not provision the agent.


Performing an agent install using the cookbook's default attributes, will setup the agent and provision the instance immediately. see *configuration #1* above.  If you have properly set your registration key, your host should appear within Alert Logic's Console within 15 minutes.

Testing
-------

In the root of the project:
* to execute rubocop: `rubocop .`
* to execute foodcritic: `foodcritic .`
* to execute chefspec: `rspec spec`
* to execute test kitchen: `kitchen test`

Kitchen Tests
-------------

Edit .kitchen.yml and uncomment the attributes section, replacing the `registration_key` attribute with your Alert Logic Unique Registration Key
``` attributes:
       al_agents:
         agent:
           registration_key: 'your_key_here'
```
Note: If you do not put your Alert Logic registration key in as an override attribute, the tests will fail when attempting to execute the provisioning recipe.

Troubleshooting
---------------

If the cookbook fails at the provisioning step, one cause is that the agent cannot connect to the egress_url.  Ensure that the proper permissions are configured on the security groups and ACLs to allow for outbound access.  Also check your egress_url attribute and ensure that it is a properly formatted URI.


## CloudInit
Alert Logic provides an [example](https://github.com/alertlogic/al-agents-cloud-init) 
for using [CloudInit](http://cloudinit.readthedocs.org/) and chef-solo to install and configure agents. 
[CloudInit](http://cloudinit.readthedocs.org/) is the way to install something
onto cloud instances (i.e. amazon ec2).
In case of amazon ec2 just pass this .yml file as `user-data`, do not forget
to change `registration_key`. If you would like to route traffic through a SOCKS 
or HTTP proxy, set the `proxy_url` value to point to your specific proxy.
This will install chef-client to your instance, download this cookbook and
run `chef-solo`.

Note that in case of amazon ec2 `user-data` will be accessible to any
user from within this instance.


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
License:
Distributed under the Apache 2.0 license.

Authors: 
John Ramos (john.ramos@dualspark.com)
Justin Early (jearly@alertlogic.com)
