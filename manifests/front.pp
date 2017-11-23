class librenms::front() inherits librenms {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin'
  }

  exec { 'librenms srcdir':
    command => "mkdir -p ${librenms::srcdir}/librenms",
    creates => "${librenms::srcdir}/librenms",
  }

  include ::librenms::code

  # useradd librenms -d /opt/librenms -M -r
  # usermod -a -G librenms nginx
  user { $librenms::username:
    ensure     => 'present',
    managehome => false,
    home       => $librenms::basedir,
    system     => true,
    groups     => $librenms::params::librenms_groups,
    require    => Class['::librenms::code'],
  }

  include ::php
  
  include ::php::fpm

}
