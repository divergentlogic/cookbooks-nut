#
# Cookbook Name:: nut
# Recipe:: default
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

package "nut"
# Precise creates the user and group called 'nut'
package "nut-snmp"

service "nut-server" do
  if node["platform_version"].to_f >= 14.04
    service_name "nut-server"
  else
    service_name "nut"
  end
  supports :start => true, :stop => true, :reload => true, :restart => true, :status => true
end


service "nut-client" do
  if node["platform_version"].to_f >= 14.04
    service_name "nut-client"
  else
    service_name "nut"
  end
  supports :start => true, :stop => true, :reload => true, :restart => true, :status => true
end

template "/etc/udev/rules.d/53-nut-serialups.rules" do
  source "nut-serialups.rules.erb"
  owner "root"
  group "root"
  mode 0644
  not_if { node['nut']['devices'].empty? }
end

template "/etc/nut/nut.conf" do
  source "nut.conf.erb"
  owner "root"
  group "root"
  mode 0644
  case node['nut']['mode']
  when "netserver"
    unless node['nut']['monitors'].nil?
      notifies :restart, 'service[nut-client]'
    end
    notifies :restart, 'service[nut-server]'
  when "netclient"
    notifies :restart, 'service[nut-client]'
  when "standalone"
    notifies :restart, 'service[nut-client]'
    notifies :restart, 'service[nut-server]'
  end
end

template "/etc/nut/ups.conf" do
  source "ups.conf.erb"
  owner "root"
  group "nut"
  mode 0640
  notifies :reload, 'service[nut-server]'
  not_if { node['nut']['ups'].empty? }
end

template "/etc/nut/upsd.conf" do
  source "upsd.conf.erb"
  owner "root"
  group "nut"
  mode 0640
  notifies :reload, 'service[nut-server]'
end


template "/etc/nut/upsd.users" do
  source "upsd.users.erb"
  owner "root"
  group "nut"
  mode 0640
  notifies :reload, 'service[nut-server]'
end

template "/etc/nut/upsmon.conf" do
  source "upsmon.conf.erb"
  owner "root"
  group "nut"
  mode 0640
  notifies :reload, 'service[nut-client]'
end

# Starting service correspond to nut.conf mode
case node['nut']['mode']

  when "netserver"
    service "nut-client" do
      action [ :enable, :start ]
      not_if { node['nut']['monitors'].nil? }
    end
    service "nut-server" do
      action [ :enable, :start ]
    end

  when "netclient"
    service "nut-client" do
      action [ :enable, :start ]
    end

  when "standalone"
    service "nut-client" do
      action [ :enable, :start ]
    end
    service "nut-server" do
      action [ :enable, :start ]
    end
  end
