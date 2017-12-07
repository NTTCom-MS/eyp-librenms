class librenms::db() inherits librenms {

  if($librenms::librenms_mysql_root_pw == 'password')
  {
    fail('Please set MySQL root password: librenms_mysql_root_pw')
  }

  if($librenms::db_password == 'password')
  {
    fail('Please set MySQL password for ${librenms::db_username}: db_password')
  }

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin'
  }

  include ::mysql

  mysql::mycnf { 'librenms':
    require => Class['::mysql'],
  }

  mysql::mycnf::client { 'default_client':
    instance_name => 'global',
    default       => true,
    password      => $librenms::librenms_mysql_root_pw,
    socket        => '/var/mysql/librenms/mysqld.sock',
  }

  mysql::mycnf::mysqld{ 'librenms':
    sql_mode            => '',
    port                => '3306',
    instancedir         => "/var/mysql/librenms",
    datadir             => "/var/mysql/librenms/datadir",
    relaylogdir         => "/var/mysql/librenms/relaylogs",
    log_error           => "/var/log/mysql/librenms/mysql-error.log",
    slow_query_log_file => "/var/log/mysql/librenms/mysql-slow.log",
    notify              => Mysql::Community::Instance['librenms'],
  }

  mysql::community::instance { 'librenms':
    port              => '3306',
    password          => $librenms::librenms_mysql_root_pw,
    add_default_mycnf => false,
  }

  mysql::backup::mysqldump { 'librenms':
    destination => $librenms::install_mysql_backup_destination,
    logdir      => $librenms::install_mysql_backup_logs,
    file_per_db => false,
  }

  exec { 'librenms::db srcdir':
    command => "mkdir -p ${librenms::srcdir}/librenms",
    creates => "${librenms::srcdir}/librenms",
  }

  file { "${librenms::srcdir}/librenms/dbinit.sql":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/mysql/initdb.erb"),
    require => Exec['librenms::db srcdir'],
  }

  # unless  => "select TABLE_SCHEMA,TABLE_NAME from information_schema.tables where TABLE_NAME='puppet_control_table' and TABLE_SCHEMA='librenms'",
  # select TABLE_SCHEMA,TABLE_NAME from information_schema.tables where TABLE_NAME='puppet_control_table' and TABLE_SCHEMA='librenms'
  mysql_sql { 'librenms db setup':
    command => "SOURCE ${librenms::srcdir}/librenms/dbinit.sql",
    unless  => "SELECT ver from ${librenms::dbname}.${librenms::db_control_table}",
    require => [ Mysql::Community::Instance['librenms'], File["${librenms::srcdir}/librenms/dbinit.sql"] ],
  }

}
