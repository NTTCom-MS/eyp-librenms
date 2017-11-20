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

  mysql_sql { 'librenms db setup':
    command => "SOURCE ${librenms::srcdir}/librenms/dbinit.sql",
  }

  # useradd librenms -d /opt/librenms -M -r
  # usermod -a -G librenms nginx

  # cd /opt
  # git clone https://github.com/librenms/librenms.git librenms

}
