# masala_kafka

This is a component of the [masala toolkit](https://github.com/PaytmLabs/masala).

This is a [wrapper cookbook](http://blog.vialstudios.com/the-environment-cookbook-pattern/#thewrappercookbook) for providing recipes for kafka server deployment. In addition to deploying brokers it also allows deployment of mirror maker, as well as confluent services.

It will enable datadog monitoring for kafka if enabled in masala_base.

## Supported Platforms

The platforms supported are:
- Centos 6.7+ / Centos 7.1+
- Ubuntu 14.04 LTS (And future LTS releases)
- Debioan 8.2+

## Attributes

Please see the documentation for the cookbooks included by masala_kafka. (See [metadata.rb](https://github.com/PaytmLabs/masala_kafka/blob/develop/metadata.rb) file)

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['masala_kafka']['zk_mode']</tt></td>
    <td>String</td>
    <td>What type of zookeeper installation to install. Valid options are 'zookeeper', 'exhibitor', and 'none'. Depending on the choice, the attributes for configuring the appropriate zookeeper provider will also need to be set.</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['masala_kafka']['zookeepers']</tt></td>
    <td>String</td>
    <td>A comma seperated list of the hosts running the zookeeper cluster, that kafka is to use.</td>
    <td><tt>localhost</tt></td>
  </tr>
</table>

## Usage

### masala_kafka::default

Include `masala_kafka` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[masala_kafka::default]"
  ]
}
```

## License, authors, and how to contribute

See:
- [LICENSE](https://github.com/PaytmLabs/masala_kafka/blob/develop/LICENSE)
- [MAINTAINERS.md](https://github.com/PaytmLabs/masala_kafka/blob/develop/MAINTAINERS.md)
- [CONTRIBUTING.md](https://github.com/PaytmLabs/masala_kafka/blob/develop/CONTRIBUTING.md)

