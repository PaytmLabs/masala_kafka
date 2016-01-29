#
# Cookbook Name:: masala_kafka
# Recipe:: confluent_install
#
# Copyright 2016, Paytm Labs
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

include_recipe 'masala_base::default'
# Ensure kafka user exists
include_recipe 'cerner_kafka::_common'

node.default["confluent"]["binary_url"] = "#{node["confluent"]["tarball_base_url"]}/confluent-#{node['confluent']['version']}-#{node['confluent']['version_suffix']}.tar.gz"
binaryFileName = File.basename(node["confluent"]["binary_url"])

# Set all default attributes that are built from other attributes
node.default["confluent"]["install_dir"] = "/opt/confluent-#{node['confluent']['version']}"

# Download confluent binary file if it does not exist already
remote_file "#{Chef::Config[:file_cache_path]}/#{binaryFileName}" do
  action :create_if_missing
  source node['confluent']['binary_url']
  mode 00644
  backup false
end

execute "untar confluent package" do
  cwd File.dirname(node['confluent']['install_dir'])
  command "tar zxf #{Chef::Config[:file_cache_path]}/#{binaryFileName}"
  not_if { File.exists?(node['confluent']['install_dir']) }
end

# Link the actual installation with the install_dir (/opt/confluent-1.0.1 -> /opt/confluent)
link node["confluent"]["install_link"] do
  owner node["kafka"]["user"]
  group node["kafka"]["group"]
  to node["confluent"]["install_dir"]
end

# Ensure everything is owned by the kafka user/group
execute "chown #{node["kafka"]["user"]}:#{node["kafka"]["group"]} -R #{node["confluent"]["install_dir"]}" do
  action :run
end

# Link config to /etc/confluent
link "/etc/confluent" do
  to "#{node["confluent"]["install_dir"]}/etc"
end
