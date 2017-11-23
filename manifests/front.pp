class librenms::front() inherits librenms {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin'
  }

  exec { 'librenms srcdir':
    command => "mkdir -p ${librenms::srcdir}/librenms",
    creates => "${librenms::srcdir}/librenms",
  }

  include ::librenms::code

  include ::php

  include ::php::fpm

  include ::nginx

}
