class librenms::memcached() inherits librenms {

  class { '::memcached':
    maxmem => $librenms::memcached_maxmem,
    port   => $librenms::memcached_port,
    listen => $librenms::memcached_listen,
    maxcon => $librenms::memcached_maxcon,
  }
}
