class librenms::front() inherits librenms {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin'
  }

  include ::librenms::code::runtime

  include ::librenms::code

  include ::php::fpm

  Php::Module <| tag == 'librenms' |>

  ->

  php::fpm::pool { 'librenms':
    user       => $librenms::username,
    group      => $librenms::username,
    socketmode => '0666',
  }

  include ::nginx

  nginx::vhost { $librenms::domain_name:
    documentroot   => "${librenms::basedir}/html",
    directoryindex => [ 'index.php' ],
    charset        => 'utf-8',
    require        => Php::Fpm::Pool['librenms'],
  }

  nginx::try_files { "try base ${librenms::domain_name}":
    servername => $librenms::domain_name,
    try        => [ '$uri', '$uri/', '/index.php?$query_string' ],
  }

  nginx::try_files { "try /api/v0 ${librenms::domain_name}":
    servername => $librenms::domain_name,
    location   => '/api/v0',
    try        => [ '$uri', '$uri/', '/api_v0.php?$query_string' ],
  }

  nginx::location { "${librenms::domain_name} php files":
    servername              => $librenms::domain_name,
    location                => '\.php',
    location_match          => '~',
    include                 => [ 'fastcgi.conf' ],
    fastcgi_split_path_info => '^(.+\.php)(/.+)$',
    fastcgi_pass            => 'unix:/var/run/php-fpm.librenms.sock',
  }

  nginx::location { "${librenms::domain_name} ht files":
    servername     => $librenms::domain_name,
    location       => '\.ht',
    location_match => '~',
    deny           => [ 'all' ],
  }


}
