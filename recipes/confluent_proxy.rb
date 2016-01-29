#
# Cookbook Name:: masala_kafka
# Recipe:: confluent_proxy
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

template "#{node["confluent"]["install_dir"]}/etc/kafka-rest/kafka-rest.properties" do
  source  "key_equals_value.erb"
  owner node["kafka"]["user"]
  group node["kafka"]["group"]
  mode  00755
  variables(
      { :properties => node["confluent"]['proxy']['conf'].to_hash }
  )
  #notifies :restart, "service[confluent-proxy]"
end

template "#{node["confluent"]["install_dir"]}/etc/kafka-rest/log4j.properties" do
  source  "key_equals_value.erb"
  owner node["kafka"]["user"]
  group node["kafka"]["group"]
  mode  00755
  variables(
      { :properties => node["confluent"]['proxy']['log4j'].to_hash }
  )
  #notifies :restart, "service[confluent-proxy]"
end

template "/etc/init.d/confluent-proxy" do
  source "confluent_proxy_initd.erb"
  owner "root"
  group "root"
  mode  00755
  notifies :restart, "service[confluent-proxy]"
end

# Start/Enable Kafka
service "confluent-proxy" do
  action [:enable, :start]
end

if node['masala_base']['dd_enable'] and not node['masala_base']['dd_api_key'].nil?
  node.set['datadog']['confluent-proxy']['instances'] = [
      {
          host: 'localhost',
          port: node['confluent']['proxy']['env']['JMX_PORT']
          #name: node['kafka']['cluster_name']
      }
  ]
  datadog_monitor 'confluent-proxy' do
    instances node['datadog']['confluent-proxy']['instances']
    cookbook 'masala_kafka'
  end
end

