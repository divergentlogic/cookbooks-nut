#
# Cookbook Name:: nut
# Resource:: ups
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
attribute :driver, :kind_of => String, :required => true
attribute :port, :kind_of => String, :required => true
attribute :desc, :kind_of => String

# sdorder: optional.  When you have multiple UPSes on your system, you
#          usually need to turn them off in a certain order.  upsdrvctl
#          shuts down all the 0s, then the 1s, 2s, and so on.  To exclude
#          a UPS from the shutdown sequence, set this to -1.
#
#          The default value for this parameter is 0.
attribute :shutdown_order, :kind_of => Fixnum

#  nolock: optional, and not recommended for use in this file.
#
#          If you put nolock in here, the driver will not lock the
#          serial port every time it starts.  This may allow other 
#          processes to seize the port if you start more than one by 
#          mistake.
#
#          This is only intended to be used on systems where locking
#          absolutely must be disabled for the software to work.

attribute :nolock, :kind_of => [TrueClass, FalseClass]

# maxstartdelay: optional.  This can be set as a global variable
#                above your first UPS definition and it can also be
#                set in a UPS section.  This value controls how long
#                upsdrvctl will wait for the driver to finish starting.
#                This keeps your system from getting stuck due to a
#                broken driver or UPS.
#
attribute :max_start_delay, :kind_of => Fixnum

# Hardware specific options
attribute :extra, :kind_of => Hash
