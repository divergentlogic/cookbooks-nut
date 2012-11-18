#
# Cookbook Name:: nut
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

maintainer       "Ceaser Larry"
maintainer_email "clarry@divergentlogic.com"
license          "Apache 2.0"
description      "Installs/Configures Network UPS Tools"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.2"
recipe           "nut", "Default recipe"

%w(debian ubuntu).each do |os|
  supports os
end

attribute "nut/mode",
    :display_name => "Startup mode",
    :description => "The mode determines which parts of NUT is to be started",
    :default => 'none'

attribute "nut/devices",
    :display_name => "Device List",
    :description => "Serial devices which need their permission changed to the NUT group ",
    :default => 'none'

attribute "nut/ups",
    :display_name => "UPS List",
    :description => "The UPS driver settings",
    :default =>  'none'

attribute "nut/users",
    :display_name => "User List",
    :description => "List of various users",
    :default =>  'none'

attribute "nut/monitors",
    :display_name => "Monitor List",
    :description => "List of systems you want to monitor",
    :default =>  'none'

attribute "nut/min_supplies",
    :display_name => "Minimal Supplies",
    :description => "The number of power supplies that must be receiving power to keep this system running",
    :default =>  "1"

attribute "nut/shutdown_command",
    :display_name => "Shutdown Command",
    :description => "This command is ran when the system needs to be brought down",
    :default =>  "/sbin/shutdown -h +0"

attribute "nut/notify_command",
    :display_name => "Notify Command",
    :description => "This command is ran when to send messages when things happen",
    :default =>  'none'

attribute "nut/poll_frequency",
    :display_name => "Poll Frequency",
    :description => "Polling frequency for normal activities",
    :default =>  "5"

attribute "nut/poll_frequency_alert",
    :display_name => "Poll Frequency while UPS on battery",
    :description => "Polling frequency in seconds while UPS on battery",
    :default =>  "5"

attribute "nut/host_sync",
    :display_name => "Host Sync",
    :description => "How long upsmon will wait before giving up on another upsmon",
    :default =>  "15"

attribute "nut/deadtime",
    :display_name => "Dead Time",
    :description => "Interval to wait before declaring a stale ups dead",
    :default =>  "15"

attribute "nut/power_down_flag",
    :display_name => "Power Down Flag",
    :description => "Flag file for forcing UPS shutdown on the master system",
    :default =>  '/etc/killpower'

attribute "nut/notifications/onilne/message",
    :display_name => "Online Message",
    :description => "Change messages sent by upsmon when UPS is back online",
    :default =>  'none'

attribute "nut/notifications/on_battery/message",
    :display_name => "On Battery Message",
    :description => "Change messages sent by upsmon when USP is on battery",
    :default =>  'none'

attribute "nut/notifications/low_battery/message",
    :display_name => "Low Battery Message",
    :description => "Change messages sent by upsmon when UPS has a low battery",
    :default =>  'none'

attribute "nut/notifications/forced_shutdown/message",
    :display_name => "Forced Shutdown Message",
    :description => "Change messages sent by upsmon when USP is being shutdown by the master",
    :default =>  'none'

attribute "nut/notifications/communication_ok/message",
    :display_name => "Communication OK Message",
    :description => "Change messages sent by upsmon when communications established with UPS",
    :default =>  'none'

attribute "nut/notifications/communication_bad/message",
    :display_name => "Communication Lost Message",
    :description => "Change messages sent by upsmon when communications lost to the UPS",
    :default =>  'none'

attribute "nut/notifications/shutdown/message",
    :display_name => "Shutdown Message",
    :description => "Change messages sent by upsmon when the system is being shutdown",
    :default =>  'none'

attribute "nut/notifications/replace_battery/message",
    :display_name => "Replace Battery Message",
    :description => "Change messages sent by upsmon when the UPS battery is bad and needs to be replaced",
    :default =>  'none'

attribute "nut/notifications/no_communication/message",
    :display_name => "No COmmunication Message",
    :description => "Change messages sent by upsmon when A UPS is unavailable",
    :default =>  'none'

attribute "nut/notifications/no_parent/message",
    :display_name => "No Parent Message",
    :description => "Change messages sent by upsmon when the process that shuts down the system has died",
    :default =>  'none'

attribute "nut/notifications/onilne/flags",
    :display_name => "Online Flag",
    :description => "Configured where notificaiton are posted when the UPS is back online",
    :default =>  'none'

attribute "nut/notifications/on_battery/flags",
    :display_name => "On Battery Flag",
    :description => "Configured where notificaiton are posted ",
    :default =>  'none'

attribute "nut/notifications/low_battery/flags",
    :display_name => "Low Battery Flag",
    :description => "Configured where notificaiton are posted ",
    :default =>  'none'

attribute "nut/notifications/forced_shutdown/flags",
    :display_name => "Forced Shutdown Flag",
    :description => "Configured where notificaiton are posted ",
    :default =>  'none'

attribute "nut/notifications/communication_ok/flags",
    :display_name => "Communication Ok Flag",
    :description => "Configured where notificaiton are posted ",
    :default =>  'none'

attribute "nut/notifications/communication_bad/flags",
    :display_name => "Communication Lost Flag",
    :description => "Configured where notificaiton are posted ",
    :default =>  'none'

attribute "nut/notifications/shutdown/flags",
    :display_name => "Shutdown Flag",
    :description => "Configured where notificaiton are posted ",
    :default =>  'none'

attribute "nut/notifications/replace_battery/flags",
    :display_name => "Replace Battery Flag",
    :description => "Configured where notificaiton are posted ",
    :default =>  'none'

attribute "nut/notifications/no_communication/flags",
    :display_name => "No Communication Flag",
    :description => "Configured where notificaiton are posted ",
    :default =>  'none'

attribute "nut/notifications/no_parent/flags",
    :display_name => "No Parent Message",
    :description => "Configured where notificaiton are posted ",
    :default =>  'none'

attribute "nut/replace_battery_warning_time",
    :display_name => "Replace Battery Warning Time",
    :description => "Replace Battery Warning Time in seconds",
    :default =>  "43200"

attribute "nut/no_communications_warning_time",
    :display_name => "No Communication Warning Time",
    :description => "No Communication Warning Time in seconds",
    :default =>  "300"

attribute "nut/final_delay",
    :display_name => "Final Delay",
    :description => "Last sleep interval before shutting down the system",
    :default =>  "5"

attribute "nut/run_as_user",
    :display_name => "Monitor user",
    :description => "Run the monitor service as another user",
    :default =>  'none'

attribute "nut/max_age",
    :display_name => "Data Max Age",
    :description => "After a UPS driver has stopped updating the data for this many seconds, upsd marks it stale and stops making that information available to clients",
    :default =>  'none'

attribute "nut/state_path",
    :display_name => "State Path",
    :description => "Tell upsd to look for the driver state sockets in 'path' rather than the default that was compiled into the program.",
    :default => 'none'

attribute "nut/listen",
    :display_name => "Listen",
    :description => "The address the server should listen for incoming connections",
    :default =>  'none'

attribute "nut/max_connections",
    :display_name => "Max connections",
    :description => "The number of connections allowed to connect",
    :default =>  'none'

attribute "nut/certificate_file",
    :display_name => "Certificate File",
    :description => "SSL Certificate File",
    :default =>  'none'
