class librenms::dependencies inherits librenms {

  # class { 'memcached': }
  # class { 'rrdtool': }
  # class { 'rrdtool::rrdcached': }

  if($librenms::install_nginx)
  {
    class { 'nginx': }
  }

  if($librenms::install_phpfpm)
  {

  }

  if($librenms::install_mysql_instance)
  {
    if($librenms::librenms_mysql_root_pw == 'password')
    {
      fail('Please set MySQL root password: librenms_mysql_root_pw')
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
      port                => '3306',
      instancedir         => "/var/mysql/librenms",
      datadir             => "/var/mysql/librenms/datadir",
      relaylogdir         => "/var/mysql/librenms/relaylogs",
      log_error           => "/var/log/mysql/librenms/mysql-error.log",
      slow_query_log_file => "/var/log/mysql/librenms/mysql-slow.log",
    }

    mysql::community::instance { 'librenms':
      port              => '3306',
      password          => $librenms::librenms_mysql_root_pw,
      add_default_mycnf => false,
    }

    if($librenms::install_mysql_backup)
    {
      mysql::backup::mysqldump { 'librenms':
        destination => $librenms::install_mysql_backup_destination,
        logs        => $librenms::install_mysql_backup_logs,
        file_per_db => false,
      }
    }

  }

}
