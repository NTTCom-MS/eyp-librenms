class librenms::service inherits librenms {

  #
  validate_bool($librenms::manage_docker_service)
  validate_bool($librenms::manage_service)
  validate_bool($librenms::service_enable)

  validate_re($librenms::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${librenms::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $librenms::manage_docker_service)
  {
    if($librenms::manage_service)
    {
      # service { $librenms::params::service_name:
      #   ensure => $librenms::service_ensure,
      #   enable => $librenms::service_enable,
      # }
    }
  }
}
