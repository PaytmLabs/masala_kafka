source "https://supermarket.chef.io"

## Due to a design decision in berkshelf to not recursively resolve dependencies, we must declare all dependencies of our dependencies, to the full depth of the recursion

# Dependencies of masala_ldap:
cookbook 'openldap', :git => 'https://github.com/PaytmLabs/chef-openldap.git', :ref => 'feature-our-fixes'
cookbook 'masala_ldap', :git => 'https://github.com/PaytmLabs/masala_ldap.git', :ref => 'develop'

# Dependencies of masala_base:
cookbook 'ixgbevf', :git => 'https://github.com/PaytmLabs/chef-ixgbevf.git', :ref => 'master'
cookbook 'system', :git => 'https://github.com/PaytmLabs/chef-system.git', :ref => 'feature-network-restart-control'
cookbook 'masala_base', :git => 'https://github.com/PaytmLabs/masala_base.git', :ref => 'develop'

# Dependencies of masala_zookeeper:
cookbook 'masala_zookeeper', :git => 'https://github.com/PaytmLabs/masala_zookeeper.git', :ref => 'develop'

# Dependencies of masala_exhibitor:
cookbook 'exhibitor', :git => 'https://github.com/PaytmLabs/chef-exhibitor.git', :ref => 'fix-runit-pin'
cookbook 'masala_exhibitor', :git => 'https://github.com/PaytmLabs/masala_exhibitor.git', :ref => 'develop'

# Dependencies of masala_kafka:
cookbook 'cerner_kafka', :git => 'https://github.com/PaytmLabs/chef-cerner_kafka.git', :ref => 'feature-ulimit-fix'

## Now load the primary metadata
metadata
