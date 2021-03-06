class librenms::poller() inherits librenms {
  # 8===D~
  include ::librenms::code::runtime

  include ::librenms::code

  include ::snmpd

  include ::fping

  file { '/etc/cron.d/librenms':
    ensure  => 'link',
    target  => "${librenms::basedir}/librenms.nonroot.cron",
    require => Class['::librenms::code'],
  }
}
