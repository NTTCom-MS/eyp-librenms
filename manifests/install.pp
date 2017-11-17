class librenms::install inherits librenms {

  if($librenms::manage_package)
  {
    package { $librenms::params::package_name:
      ensure => $librenms::package_ensure,
    }
  }

}
