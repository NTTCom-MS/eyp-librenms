class librenms::params {

  case $::osfamily
  {
    'redhat':
    {
      case $::operatingsystemrelease
      {
        /^[7].*$/:
        {
          # https://docs.librenms.org/#Installation/Installation-CentOS-7-Nginx/
          $librenms_groups = [ 'nginx' ]
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    'Debian':
    {
      fail('Unsupported')
      case $::operatingsystem
      {
        'Ubuntu':
        {
          $librenms_groups = [ 'www-data' ]
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
            }
            /^16.*$/:
            {
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
