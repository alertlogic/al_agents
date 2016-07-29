al_agents CHANGELOG
==================

This file is used to list changes made in each version of the al_agents cookbook.

1.3.6
-----
- Justin Early - Use rpm package library when rhel >= 6

1.3.5
-----
- Andrés Vargas - Make package repository configurable

1.3.4
------
- Justin Early - Restoring respond_to feature from commit a08589a

1.3.3
------
- Justin Early - Adjust configure_options to pass host and port separately.

1.3.2
------
- Fred Reimer - Add port for selinux instead of using resource name

1.3.1
------
- Justin Early - Extend batch resources to avoid conflicts

1.3.0
------
- Justin Early - adding ignore_failure attribute

1.2.0
------
- Justin Early - Setting for_imaging attribute to trigger agent install without configuring or provisioning

1.1.1
------
- Justin Early - Removing port from egress url

1.1.0
------
- Justin Early - Deprecating --inst-type role from provisioning options

1.0.10
------
- Justin Early - pin al-agent package version to >=0 to avoid error in Chef 12

1.0.9
-----
- Spencer Owen / Justin Early - Fix windows_guard issue opening .pem file. Fix for_imaging logic

1.0.8
-----
- Justin Early - Set syslog_ng to use s_all for CentOS version 6 and up

1.0.7
-----
- Justin Early - Pin rsyslog cookbook to version 2.2.0

1.0.6
-----
- Justin Early - Added CloudInit example and updated license

1.0.5
-----
- Justin Early - fixed rhel6x al-agent package installation

1.0.4
-----
- Justin Early - added proxy option for new agent package

1.0.3
-----
- John Ramos - added namespace feature for helpers

1.0.2
-----
- John Ramos - major refactor cookbook

0.1.2
-----
- John Ramos - changed the name of the cookbook from al_agent to al_agents

0.1.1
-----
- John Ramos - Fixed source and image urls

0.1.0
-----
- John Ramos - Initial release of al_agents

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
