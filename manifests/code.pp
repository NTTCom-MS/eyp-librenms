class librenms::code() inherits librenms {
  # cd /opt
  # git clone https://github.com/librenms/librenms.git librenms

  exec { 'eyp-librenms which git':
    command => 'which git',
    unless  => 'which git',
  }

  exec { 'git librenms':
    command => "git clone https://github.com/librenms/librenms.git ${librenms::basedir}",
    creates => "${librenms::basedir}/README.md",
    timeout => 0,
    require => Exec['eyp-librenms which git'],
  }
}
