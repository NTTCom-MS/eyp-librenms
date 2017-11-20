class librenms(
                $manage_service        = true,
                $manage_docker_service = true,
                $service_ensure        = 'running',
                $service_enable        = true,
                $librenms_mysql_root_pw = 'password',
              ) inherits librenms::params{

  class { '::librenms::dependencies': }
  -> class { '::librenms::install': }
  -> class { '::librenms::config': }
  ~> class { '::librenms::service': }
  -> Class['::librenms']

}
