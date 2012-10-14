#
# Cookbook Name:: nut
# Resource:: user
#
# Author:: Ceaser Larry (<clarry@divergentlogic.com>)
#
# Copyright 2012, Divergent Logic, LLC
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

actions :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :password, :kind_of => String, :required => true
attribute :desc, :kind_of => String
 
# action:
# Valid actions are:
# SET   - change the value of certain variables in the UPS
# FSD   - set the "forced shutdown" flag in the UPS
attribute :actions, :kind_of => String, :callbacks => {}

# instant_commands: Let the user initiate specific instant commands.  Use "ALL"
# to grant all commands automatically.  There are many possible  
# commands, so use 'upscmd -l' to see what your hardware supports.  Here
# are a few examples:
#
# test.panel.start      - Start a front panel test
# test.battery.start    - Start battery test
# test.battery.stop     - Stop battery test
# calibrate.start       - Start calibration
# calibrate.stop        - Stop calibration
attribute :instant_commands, :kind_of => String

# upsmon: Adds a user for the monitor. Can be a 'master' or 'slave'
attribute :upsmon, :kind_of => String
