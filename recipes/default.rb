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

service "nut" do
  action [ :nothing ]
  supports :start => true, :stop => true, :reload => true, :restart => true, :status => true
end

unless node['nut']['devices'].empty?
  template "/etc/udev/rules.d/53-nut-serialups.rules" do
    source "nut-serialups.rules.erb"
    owner "root"
    group "root"
    mode 0644
  end
end

template "/etc/nut/nut.conf" do
  source "nut.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[nut]'
end

unless node['nut']['ups'].empty?
  template "/etc/nut/ups.conf" do
    source "ups.conf.erb"
    owner "root"
    group "nut"
    mode 0640
    notifies :reload, 'service[nut]'
  end
end

template "/etc/nut/upsd.conf" do
  source "upsd.conf.erb"
  owner "root"
  group "nut"
  mode 0640
  notifies :reload, 'service[nut]'
end


template "/etc/nut/upsd.users" do
  source "upsd.users.erb"
  owner "root"
  group "nut"
  mode 0640
end

template "/etc/nut/upsmon.conf" do
  source "upsmon.conf.erb"
  owner "root"
  group "nut"
  mode 0640
  notifies :reload, 'service[nut]'
end

