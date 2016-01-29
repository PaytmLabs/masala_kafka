#
# Cookbook Name:: masala_kafka
# Recipe:: confluent_registry
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

include_recipe 'masala_kafka::confluent_install'

template "#{node["confluent"]["install_dir"]}/etc/schema-registry/schema-registry.properties" do
  source  "key_equals_value.erb"
  owner node["kafka"]["user"]
  group node["kafka"]["group"]
  mode  00755
  variables(
      { :properties => node["confluent"]['registry']['conf'].to_hash }
  )
  #notifies :restart, "service[confluent-registry]"
end

template "#{node["confluent"]["install_dir"]}/etc/schema-registry/log4j.properties" do
  source  "key_equals_value.erb"
  owner node["kafka"]["user"]
  group node["kafka"]["group"]
  mode  00755
  variables(
      { :properties => node["confluent"]['registry']['log4j'].to_hash }
  )
  #notifies :restart, "service[confluent-registry]"
end

template "/etc/init.d/confluent-registry" do
  source "confluent_registry_initd.erb"
  owner "root"
  group "root"
  mode  00755
  notifies :restart, "service[confluent-registry]"
end

# Start/Enable Kafka
service "confluent-registry" do
  action [:enable, :start]
end

if node['masala_base']['dd_enable'] and not node['masala_base']['dd_api_key'].nil?
  node.set['datadog']['confluent-registry']['instances'] = [
      {
          host: 'localhost',
          port: node['confluent']['registry']['env']['JMX_PORT']
          #name: node['kafka']['cluster_name']
      }
  ]
  datadog_monitor 'confluent-registry' do
    instances node['datadog']['confluent-registry']['instances']
    cookbook 'masala_kafka'
  end
end

