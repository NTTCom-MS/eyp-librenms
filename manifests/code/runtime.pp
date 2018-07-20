class librenms::code::runtime inherits librenms {

  class { '::php':
    use_php_package_prefix_ius => $librenms::php_package_ius,
  }

  # php71w-curl
  # php71w-zip

  php::module { 'php-xml':
    tag     => 'librenms',
    require => Class['::php'],
  }

  php::module { 'php-process':
    tag     => 'librenms',
    require => Class['::php'],
  }

  php::module { 'php-gd':
    tag     => 'librenms',
    require => Class['::php'],
  }

  php::module { 'php-mysqlnd':
    tag     => 'librenms',
    require => Class['::php'],
  }

  php::module { 'php-mcrypt':
    tag     => 'librenms',
    require => Class['::php'],
  }

  php::module { 'php-snmp':
    tag     => 'librenms',
    require => Class['::php'],
  }

  if($librenms::use_memcached)
  {
    php::module { $librenms::params::php_memcached_extesion:
      tag     => 'librenms',
      require => Class['::php'],
    }
  }

}
