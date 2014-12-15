#
# Cookbook Name:: al_agents
#
# Copyright (c) 2014, Alert Logic.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name             'al_agents'
maintainer       'Alert Logic'
maintainer_email 'support@alertlogic.com'
license          'Apache 2.0'
description      'Installs and configures log and threat agents'
version          '0.2.0'

recipe            "al_agents::agent", "Installs AL Universal agent"

%w{ubuntu debian centos redhat fedora}.each do |os|
  supports os
end
