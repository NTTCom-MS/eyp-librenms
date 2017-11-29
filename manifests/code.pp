class librenms::code() inherits librenms {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin'
  }

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

  # useradd librenms -d /opt/librenms -M -r
  # usermod -a -G librenms nginx
  user { $librenms::username:
    ensure     => 'present',
    managehome => false,
    home       => $librenms::basedir,
    system     => true,
    groups     => $librenms::params::librenms_groups,
    require    => Exec['git librenms'],
  }

  # chown -R librenms:librenms /opt/librenms
  file { $librenms::basedir:
    ensure  => 'directory',
    owner   => $librenms::username,
    group   => $librenms::username,
    mode    => '0755',
    require => Exec['git librenms'],
  }

  file { "${librenms::basedir}/config.php":
    ensure  => 'present',
    owner   => $librenms::username,
    group   => $librenms::username,
    mode    => '0640',
    content => template("${module_name}/librenms/config.erb"),
    require => File[$librenms::basedir],
  }
}
