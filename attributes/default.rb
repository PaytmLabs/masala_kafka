
# our local default version(s)
default["kafka"]["scala_version"] = "2.10"
default["kafka"]["version"] = "0.8.2.2"

# one of 'exhibitor', 'zookeeper', 'none' (default)
default['masala_kafka']['zk_mode'] = 'none'
default['masala_kafka']['zookeepers'] = ['localhost']

# List of topics to get individual metrics
default['masala_kafka']['topics_monitored'] = []

# FIXME: move to masala_kafka
default['kafka']['cluster_name'] = 'testcluster'

# Cerner kafka uses defaults different than kafka, reset these back to kafka default
default["kafka"]["server.properties"]["auto.create.topics.enable"] = "false"
default["kafka"]["server.properties"]["delete.topic.enable"] = "false"
default["kafka"]["server.properties"]["log.flush.interval.messages"] = 10000
default["kafka"]["server.properties"]["log.retention.check.interval.ms"] = 3600000
default["kafka"]["server.properties"]["replica.lag.max.messages"] = 4000
default["kafka"]["server.properties"]["replica.fetch.wait.max.ms"] = 500
default["kafka"]["server.properties"]["num.replica.fetchers"] = 1
default["kafka"]["server.properties"]["num.network.threads"] = 3

# Even at info the main log can be very verbose. Dial it down
default["kafka"]["log4j.properties"]["log4j.rootLogger"] = "WARN"
default["kafka"]["log4j.properties"]["log4j.appender.kafkaAppender.MaxBackupIndex"] = "10"
default["kafka"]["log4j.properties"]["log4j.logger.kafka"] = "WARN, kafkaAppender"

# use the new broker port
default["kafka"]["server.properties"]["port"] = 9092

default["kafka"]["server.properties"]["num.partitions"] = 16
default["kafka"]["server.properties"]["log.retention.hours"] = 4*7*24
default["kafka"]["server.properties"]["default.replication.factor"] = 2

# For our local addition of confluent:
default['confluent']['version'] = '1.0.1'
default['confluent']['version_suffix'] = '2.10.4'
default['confluent']['tarball_base_url'] = "http://packages.confluent.io/archive/1.0"
default['confluent']['tarball_checksum'] = 'e8a6b87075fa1a6505bcbf00e38d840c9503550a3b6ac4c454cdc73132f0271f'
default['confluent']['install_link'] = '/opt/confluent'

default['confluent']['registry']['stdout'] = File.join node["kafka"]["log_dir"], "confluent_registry_init_stdout.log"
default['confluent']['registry']['stderr'] = File.join node["kafka"]["log_dir"], "confluent_registry_init_stderr.log"
default['confluent']['registry']['env']['JMX_PORT'] = '9997'
default['confluent']['registry']['env']['SCHEMA_REGISTRY_HEAP_OPTS'] = '-Xms1g -Xmx1g'
default['confluent']['registry']['env']['SCHEMA_REGISTRY_LOG4J_OPTS'] = "-Dlog4j.configuration=file:#{node['confluent']['install_link']}/etc/schema-registry/log4j.properties"

default['confluent']['registry']['conf']['port'] = '8081'
default['confluent']['registry']['conf']['kafkastore.connection.url'] = 'localhost:2181'
default['confluent']['registry']['conf']['kafkastore.topic'] = '_schemas'
default['confluent']['registry']['conf']['debug'] = 'false'

default['confluent']['registry']['log4j']['log4j.rootLogger'] = 'INFO, requestAppender'
default['confluent']['registry']['log4j']['log4j.appender.stdout'] = 'org.apache.log4j.ConsoleAppender'
default['confluent']['registry']['log4j']['log4j.appender.stdout.layout'] = 'org.apache.log4j.PatternLayout'
default['confluent']['registry']['log4j']['log4j.appender.stdout.layout.ConversionPattern'] = '[%d] %p %m (%c:%L)%n'
default['confluent']['registry']['log4j']['log4j.logger.kafka'] = 'ERROR, requestAppender'
default['confluent']['registry']['log4j']['log4j.logger.org.apache.zookeeper'] = 'ERROR, requestAppender'
default['confluent']['registry']['log4j']['log4j.logger.org.apache.kafka'] = 'ERROR, requestAppender'
default['confluent']['registry']['log4j']['log4j.logger.org.I0Itec.zkclient'] = 'ERROR, requestAppender'
default['confluent']['registry']['log4j']['log4j.additivity.kafka.server'] = 'false'
default['confluent']['registry']['log4j']['log4j.additivity.kafka.consumer.ZookeeperConsumerConnector'] = 'false'
default['confluent']['registry']['log4j']['schema_registry.logs.dir'] = node['kafka']['log_dir']
default['confluent']['registry']['log4j']['log4j.appender.requestAppender'] = 'org.apache.log4j.RollingFileAppender'
default['confluent']['registry']['log4j']['log4j.appender.requestAppender.MaxBackupIndex'] = "80"
default['confluent']['registry']['log4j']['log4j.appender.requestAppender.MaxFileSize'] = "50MB"
default['confluent']['registry']['log4j']['log4j.appender.requestAppender.layout'] = 'org.apache.log4j.PatternLayout'
default['confluent']['registry']['log4j']['log4j.appender.requestAppender.layout.ConversionPattern='] = '[%d] %p %m (%c)%n'
default['confluent']['registry']['log4j']['log4j.appender.requestAppender.File'] = '${schema_registry.logs.dir}/confluent_registry_request.log'

default['confluent']['proxy']['stdout'] = File.join node['kafka']['log_dir'], "confluent_proxy_init_stdout.log"
default['confluent']['proxy']['stderr'] = File.join node['kafka']['log_dir'], "confluent_proxy_init_stderr.log"
default['confluent']['proxy']['env']['JMX_PORT'] = '9996'
default['confluent']['proxy']['env']['KAFKAREST_HEAP_OPTS'] = '-Xms1g -Xmx1g'
default['confluent']['proxy']['env']['KAFKAREST_LOG4J_OPTS'] = "-Dlog4j.configuration=file:#{node['confluent']['install_link']}/etc/kafka-rest/log4j.properties"

default['confluent']['proxy']['conf']['id'] = 'kafka-rest-test-server'
default['confluent']['proxy']['conf']['schema.registry.url'] = 'http://localhost:8081'
default['confluent']['proxy']['conf']['zookeeper.connect'] = 'localhost:2181'

default['confluent']['proxy']['log4j']['kafka_rest.logs.dir'] = node['kafka']['log_dir']
default['confluent']['proxy']['log4j']['log4j.rootLogger'] = 'INFO, requestAppender'
default['confluent']['proxy']['log4j']['log4j.appender.stdout'] = 'org.apache.log4j.ConsoleAppender'
default['confluent']['proxy']['log4j']['log4j.appender.stdout.layout'] = 'org.apache.log4j.PatternLayout'
default['confluent']['proxy']['log4j']['log4j.appender.stdout.layout.ConversionPattern'] = '[%d] %p %m (%c:%L)%n'
default['confluent']['proxy']['log4j']['log4j.appender.requestAppender'] = 'org.apache.log4j.RollingFileAppender'
default['confluent']['proxy']['log4j']['log4j.appender.requestAppender.MaxBackupIndex'] = "80"
default['confluent']['proxy']['log4j']['log4j.appender.requestAppender.MaxFileSize'] = "50MB"
default['confluent']['proxy']['log4j']['log4j.appender.requestAppender.layout'] = 'org.apache.log4j.PatternLayout'
default['confluent']['proxy']['log4j']['log4j.appender.requestAppender.layout.ConversionPattern'] = '%d{ISO8601} %p %c: %m%n'
default['confluent']['proxy']['log4j']['log4j.appender.requestAppender.File'] = '${kafka_rest.logs.dir}/confluent_rest_request.log'

