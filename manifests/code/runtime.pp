class librenms::code::runtime inherits librenms {

  class { '::php':
    use_php_package_prefix_ius => $librenms::php_package_ius,
  }

  # php71w-curl
  # php71w-zip

  php::module { 'php-xml':
    tag => 'librenms'
  }

  php::module { 'php-process':
    tag => 'librenms'
  }

  php::module { 'php-gd':
    tag => 'librenms'
  }

  php::module { 'php-mysqlnd':
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
