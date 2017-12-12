class librenms::code::runtime inherits librenms {

  include ::php

  php::module { 'php-gd':
    tag => 'librenms'
  }

  php::module { 'php-pear-MDB2-Driver-mysqli':
    tag => 'librenms'
  }

  php::module { 'php-mcrypt':
    tag => 'librenms'
  }

  php::module { 'php-snmp':
    tag => 'librenms'
  }

  if($librenms::use_memcached)
  {
    php::module { $librenms::params::php_memcached_extesion:
      tag => 'librenms'
    }
  }

}
