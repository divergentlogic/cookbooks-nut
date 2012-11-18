#
# Cookbook Name:: nut
# Attribute:: default
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

default['nut']['mode'] = 'none'

# The devices connected to the UPS.
default['nut']['devices'] = []

# UPS Settings
default['nut']['ups'] = {}

default['nut']['users'] = {}

# --------------------------------------------------------------------------
# MONITOR <system> <powervalue> <username> <password> ("master"|"slave")
#
# List systems you want to monitor.  Not all of these may supply power
# to the system running upsmon, but if you want to watch it, it has to
# be in this section.
#
# You must have at least one of these declared.
#
# <system> is a UPS identifier in the form <upsname>@<hostname>[:<port>]
# like ups@localhost, su700@mybox, etc.
#
# Examples:
#
#  - "su700@mybox" means a UPS called "su700" on a system called "mybox"
#
#  - "fenton@bigbox:5678" is a UPS called "fenton" on a system called
#    "bigbox" which runs upsd on port "5678".
#
# The UPS names like "su700" and "fenton" are set in your ups.conf
# in [brackets] which identify a section for a particular driver.
#
# If the ups.conf on host "doghouse" has a section called "snoopy", the
# identifier for it would be "snoopy@doghouse".
#
# <powervalue> is an integer - the number of power supplies that this UPS
# feeds on this system.  Most computers only have one power supply, so this
# is normally set to 1.  You need a pretty big or special box to have any
# other value here.
#
# You can also set this to 0 for a system that doesn't supply any power,
# but you still want to monitor.  Use this when you want to hear about
# changes for a given UPS without shutting down when it goes critical,
# unless <powervalue> is 0.
#
# <username> and <password> must match an entry in that system's
# upsd.users.  If your username is "monmaster" and your password is
# "blah", the upsd.users would look like this:
#
#	[monmaster]
#		password  = blah
#		upsmon master 	(or slave)
#
# "master" means this system will shutdown last, allowing the slaves
# time to shutdown first.
#
# "slave" means this system shuts down immediately when power goes critical.
#
# Examples:
#
# MONITOR myups@bigserver 1 monmaster blah master
# MONITOR su700@server.example.com 1 upsmon secretpass slave
# MONITOR myups@localhost 1 upsmon pass master	(or slave)
default['nut']['monitors'] = {}
# {"cyberpower": {
#   # <system> is a UPS identifier in the form <upsname>@<hostname>[:<port>]
#   # like ups@localhost, su700@mybox, etc.
#   "system" => "cyberpower@localhost",
#   
#   # <powervalue> is an integer - the number of power supplies that this UPS
#   # feeds on this system.  Most computers only have one power supply, so this
#   # is normally set to 1.  You need a pretty big or special box to have any
#   # other value here.
#   #
#   # You can also set this to 0 for a system that doesn't supply any power,
#   # but you still want to monitor.  Use this when you want to hear about
#   # changes for a given UPS without shutting down when it goes critical,
#   # unless <powervalue> is 0.
#   "power_value" => 1,
#   
#   "username" => "admin",
#   "password" => "",
#   "role" => "master"
# }}

# Give the number of power supplies that must be receiving power to keep
# this system running.  Most systems have one power supply, so you would
# put "1" in this field.
#
# Large/expensive server type systems usually have more, and can run with
# a few missing.  The HP NetServer LH4 can run with 2 out of 4, for example,
# so you'd set that to 2.  The idea is to keep the box running as long
# as possible, right?
#
# Obviously you have to put the redundant supplies on different UPS circuits
# for this to make sense!  See big-servers.txt in the docs subdirectory
# for more information and ideas on how to use this feature.
default['nut']['min_supplies'] = 1

# upsmon runs this command when the system needs to be brought down.
default['nut']['shutdown_command'] = "/sbin/shutdown -h +0"

# upsmon calls this to send messages when things happen
#
# This command is called with the full text of the message as one argument.
# The environment string NOTIFYTYPE will contain the type string of
# whatever caused this event to happen.
#
# Note that this is only called for NOTIFY events that have EXEC set with
# NOTIFYFLAG.  See NOTIFYFLAG below for more details.
#
# Making this some sort of shell script might not be a bad idea.  For more
# information and ideas, see pager.txt in the docs directory.
default['nut']['notify_command'] = nil

# Polling frequency for normal activities, measured in seconds.
#
# Adjust this to keep upsmon from flooding your network, but don't make
# it too high or it may miss certain short-lived power events.
default['nut']['poll_frequency'] = 5

# Polling frequency in seconds while UPS on battery.
#
# You can make this number lower than POLLFREQ, which will make updates
# faster when any UPS is running on battery.  This is a good way to tune
# network load if you have a lot of these things running.
#
# The default is 5 seconds for both this and POLLFREQ.
default['nut']['poll_frequency_alert'] = 5

# --------------------------------------------------------------------------
# HOSTSYNC - How long upsmon will wait before giving up on another upsmon
#
# The master upsmon process uses this number when waiting for slaves to
# disconnect once it has set the forced shutdown (FSD) flag.  If they
# don't disconnect after this many seconds, it goes on without them.
#
# Similarly, upsmon slave processes wait up to this interval for the
# master upsmon to set FSD when a UPS they are monitoring goes critical -
# that is, on battery and low battery.  If the master doesn't do its job,
# the slaves will shut down anyway to avoid damage to the file systems.
#
# This "wait for FSD" is done to avoid races where the status changes
# to critical and back between polls by the master.
default['nut']['host_sync'] = 15

# --------------------------------------------------------------------------
# DEADTIME - Interval to wait before declaring a stale ups "dead"
#
# upsmon requires a UPS to provide status information every few seconds
# (see POLLFREQ and POLLFREQALERT) to keep things updated.  If the status
# fetch fails, the UPS is marked stale.  If it stays stale for more than
# DEADTIME seconds, the UPS is marked dead.
#
# A dead UPS that was last known to be on battery is assumed to have gone
# to a low battery condition.  This may force a shutdown if it is providing
# a critical amount of power to your system.
#
# Note: DEADTIME should be a multiple of POLLFREQ and POLLFREQALERT.
# Otherwise you'll have "dead" UPSes simply because upsmon isn't polling
# them quickly enough.  Rule of thumb: take the larger of the two
# POLLFREQ values, and multiply by 3.
default['nut']['deadtime'] = 15

# --------------------------------------------------------------------------
# POWERDOWNFLAG - Flag file for forcing UPS shutdown on the master system
#
# upsmon will create a file with this name in master mode when it's time
# to shut down the load.  You should check for this file's existence in
# your shutdown scripts and run 'upsdrvctl shutdown' if it exists.
#
# See the shutdown.txt file in the docs subdirectory for more information.
default['nut']['power_down_flag'] = '/etc/killpower'

# --------------------------------------------------------------------------
# NOTIFYMSG - change messages sent by upsmon when certain events occur
#
# You can change the default messages to something else if you like.
#
# NOTIFYMSG <notify type> "message"
#

# NOTIFYMSG ONBATT	"UPS %s on battery"
# NOTIFYMSG LOWBATT	"UPS %s battery is low"
# NOTIFYMSG FSD		"UPS %s: forced shutdown in progress"
# NOTIFYMSG COMMOK	"Communications with UPS %s established"
# NOTIFYMSG COMMBAD	"Communications with UPS %s lost"
# NOTIFYMSG SHUTDOWN	"Auto logout and shutdown proceeding"
# NOTIFYMSG REPLBATT	"UPS %s battery needs to be replaced"
# NOTIFYMSG NOCOMM	"UPS %s is unavailable"
# NOTIFYMSG NOPARENT	"upsmon parent process died - shutdown impossible"
#
# Note that %s is replaced with the identifier of the UPS in question.
#
# Possible values for <notify type>:
#
# ONLINE   : UPS is back online
# ONBATT   : UPS is on battery
# LOWBATT  : UPS has a low battery (if also on battery, it's "critical")
# FSD      : UPS is being shutdown by the master (FSD = "Forced Shutdown")
# COMMOK   : Communications established with the UPS
# COMMBAD  : Communications lost to the UPS
# SHUTDOWN : The system is being shutdown
# REPLBATT : The UPS battery is bad and needs to be replaced
# NOCOMM   : A UPS is unavailable (can't be contacted for monitoring)
# NOPARENT : The process that shuts down the system has died (shutdown impossible)
default['nut']['notifications']['onilne']['message'] = nil
default['nut']['notifications']['on_battery']['message'] = nil
default['nut']['notifications']['low_battery']['message'] = nil
default['nut']['notifications']['forced_shutdown']['message'] = nil
default['nut']['notifications']['communication_ok']['message'] = nil
default['nut']['notifications']['communication_bad']['message'] = nil
default['nut']['notifications']['shutdown']['message'] = nil
default['nut']['notifications']['replace_battery']['message'] = nil
default['nut']['notifications']['no_communication']['message'] = nil
default['nut']['notifications']['no_parent']['message'] = nil

# --------------------------------------------------------------------------
# NOTIFYFLAG - change behavior of upsmon when NOTIFY events occur
#
# By default, upsmon sends walls (global messages to all logged in users)
# and writes to the syslog when things happen.  You can change this.
#
# NOTIFYFLAG <notify type> <flag>[+<flag>][+<flag>] ...
#
# NOTIFYFLAG ONLINE	SYSLOG+WALL
# NOTIFYFLAG ONBATT	SYSLOG+WALL
# NOTIFYFLAG LOWBATT	SYSLOG+WALL
# NOTIFYFLAG FSD	SYSLOG+WALL
# NOTIFYFLAG COMMOK	SYSLOG+WALL
# NOTIFYFLAG COMMBAD	SYSLOG+WALL
# NOTIFYFLAG SHUTDOWN	SYSLOG+WALL
# NOTIFYFLAG REPLBATT	SYSLOG+WALL
# NOTIFYFLAG NOCOMM	SYSLOG+WALL
# NOTIFYFLAG NOPARENT	SYSLOG+WALL
#
# Possible values for the flags:
#
# SYSLOG - Write the message in the syslog
# WALL   - Write the message to all users on the system
# EXEC   - Execute NOTIFYCMD (see above) with the message
# IGNORE - Don't do anything
#
# If you use IGNORE, don't use any other flags on the same line.
default['nut']['notifications']['onilne']['flags'] = "WALL+SYSLOG"
default['nut']['notifications']['on_battery']['flags'] = "WALL+SYSLOG"
default['nut']['notifications']['low_battery']['flags'] = "WALL+SYSLOG"
default['nut']['notifications']['forced_shutdown']['flags'] = "WALL+SYSLOG"
default['nut']['notifications']['communication_ok']['flags'] = "WALL+SYSLOG"
default['nut']['notifications']['communication_bad']['flags'] = "WALL+SYSLOG"
default['nut']['notifications']['shutdown']['flags'] = "WALL+SYSLOG"
default['nut']['notifications']['replace_battery']['flags'] = "WALL+SYSLOG"
default['nut']['notifications']['no_communication']['flags'] = "WALL+SYSLOG"
default['nut']['notifications']['no_parent']['flags'] = "WALL+SYSLOG"

# --------------------------------------------------------------------------
# RBWARNTIME - replace battery warning time in seconds
#
# upsmon will normally warn you about a battery that needs to be replaced
# every 43200 seconds, which is 12 hours.  It does this by triggering a
# NOTIFY_REPLBATT which is then handled by the usual notify structure
# you've defined above.
#
# If this number is not to your liking, override it here.
default['nut']['replace_battery_warning_time'] = 43200

# --------------------------------------------------------------------------
# NOCOMMWARNTIME - no communications warning time in seconds
#
# upsmon will let you know through the usual notify system if it can't
# talk to any of the UPS entries that are defined in this file.  It will
# trigger a NOTIFY_NOCOMM by default every 300 seconds unless you
# change the interval with this directive.
default['nut']['no_communications_warning_time'] = 300

# --------------------------------------------------------------------------
# FINALDELAY - last sleep interval before shutting down the system
#
# On a master, upsmon will wait this long after sending the NOTIFY_SHUTDOWN
# before executing your SHUTDOWNCMD.  If you need to do something in between
# those events, increase this number.  Remember, at this point your UPS is
# almost depleted, so don't make this too high.
#
# Alternatively, you can set this very low so you don't wait around when
# it's time to shut down.  Some UPSes don't give much warning for low
# battery and will require a value of 0 here for a safe shutdown.
#
# Note: If FINALDELAY on the slave is greater than HOSTSYNC on the master,
# the master will give up waiting for the slave to disconnect.
default['nut']['final_delay'] = 5

default['nut']['run_as_user'] = nil

# =======================================================================
# MAXAGE <seconds>
# MAXAGE 15
#
# This defaults to 15 seconds.  After a UPS driver has stopped updating
# the data for this many seconds, upsd marks it stale and stops making
# that information available to clients.  After all, the only thing worse
# than no data is bad data.
#
# You should only use this if your driver has difficulties keeping
# the data fresh within the normal 15 second interval.  Watch the syslog
# for notifications from upsd about staleness.
default['nut']['max_age'] = nil

# =======================================================================
# STATEPATH <path>
# STATEPATH /var/run/nut
#
# Tell upsd to look for the driver state sockets in 'path' rather
# than the default that was compiled into the program.
default['nut']['state_path'] = nil

# =======================================================================
# LISTEN <address> [<port>]
# LISTEN 127.0.0.1 3493
# LISTEN ::1 3493
#
# This defaults to the localhost listening addresses and port 3493.
# In case of IP v4 or v6 disabled kernel, only the available one will be used.
#
# You may specify each interface you want upsd to listen on for connections,
# optionally with a port number.
#
# You may need this if you have multiple interfaces on your machine and
# you don't want upsd to listen to all interfaces (for instance on a
# firewall, you may not want to listen to the external interface).
#
# This will only be read at startup of upsd.  If you make changes here,
# you'll need to restart upsd, reload will have no effect.
default['nut']['listen'] = nil

# =======================================================================
# MAXCONN <connections>
# MAXCONN 1024
#
# This defaults to maximum number allowed on your system.  Each UPS, each
# LISTEN address and each client count as one connection.  If the server
# runs out of connections, it will no longer accept new incoming client
# connections.  Only set this if you know exactly what you're doing.
default['nut']['max_connections'] = nil

# =======================================================================
# CERTFILE <certificate file>
#
# When compiled with SSL support, you can enter the certificate file here.
# The certificates must be in PEM format and must be sorted starting with
# the subject's certificate (server certificate), followed by intermediate
# CA certificates (if applicable_ and the highest level (root) CA. It should
# end with the server key. See 'docs/security.txt' or the Security chapter of
# NUT user manual for more information on the SSL support in NUT.
default['nut']['certificate_file'] = nil
