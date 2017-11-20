class librenms(
                $manage_service         = true,
                $manage_docker_service  = true,
                $service_ensure         = 'running',
                $service_enable         = true,
                $librenms_mysql_root_pw = 'password',
                $dbname                 = 'librenms',
                $db_username            = 'librenms',
                $db_password            = 'password',
                $db_host                = 'localhost',
                $db_is_default_instance = true,
                $db_control_table       = 'puppet_control_table',
                $srcdir                 = '/usr/local/src',
              ) inherits librenms::params{

  class { '::librenms::dependencies': }
  -> class { '::librenms::install': }
  -> class { '::librenms::config': }
  ~> class { '::librenms::service': }
  -> Class['::librenms']

}
