class librenms::install inherits librenms {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin'
  }

  exec { 'librenms srcdir':
    command => "mkdir -p ${librenms::srcdir}/librenms",
    creates => "${librenms::srcdir}/librenms",
  }

  file { "${librenms::srcdir}/librenms/dbinit.sql":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/mysql/initdb.erb"),
    require => Exec['librenms srcdir'],
  }

  # unless  => "select TABLE_SCHEMA,TABLE_NAME from information_schema.tables where TABLE_NAME='puppet_control_table' and TABLE_SCHEMA='librenms'",
  # select TABLE_SCHEMA,TABLE_NAME from information_schema.tables where TABLE_NAME='puppet_control_table' and TABLE_SCHEMA='librenms'
  mysql_sql { 'librenms db setup':
    command => "SOURCE ${librenms::srcdir}/librenms/dbinit.sql",
    unless  => "SELECT ver from ${librenms::dbname}.${librenms::db_control_table}",
    require => File["${librenms::srcdir}/librenms/dbinit.sql"],
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

}
