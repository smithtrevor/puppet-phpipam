# == Class phpipam::config
#
# This class is called from phpipam
#
class phpipam::config {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $::phpipam::manage_apache {
      $ssl_config = deep_merge($::phpipam::params::ssl_params_hash, $::phpipam::ssl_options)

    if $::phpipam::ssl_enabled {
      $listen_port = 443

      apache::vhost { 'phpipam-http-redirect':
        ip                => '*',
        port              => '80',
        servername        => $::phpipam::site_fqdn,
        ssl               => false,
        ip_based          => false,
        access_log_format => 'combined',
        docroot           => $phpipam::apache_docroot,
        directories       => [
          {
            path     => '/',
            rewrites => [
              {
                rewrite_cond => ['%{HTTPS} !=on'],
                rewrite_rule => ['(.*) https://%{HTTP_HOST}%{REQUEST_URI}'],
              }
            ],
          }
        ],
      }


      if $::phpipam::ssl_certificate {

        validate_absolute_path($::phpipam::config::ssl_config['ssl_cert'])

        file { $::phpipam::config::ssl_config['ssl_cert']:
          ensure  => file,
          owner   => 'root',
          group   => $::phpipam::apache_group,
          mode    => '0640',
          content => $::phpipam::ssl_certificate,
          notify  => Service[$::apache::params::service_name],
        }
      }

      if $::phpipam::ssl_key {

        validate_absolute_path($::phpipam::config::ssl_config['ssl_key'])

        file { $::phpipam::config::ssl_config['ssl_key']:
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0600',
          content => $::phpipam::ssl_key,
          notify  => Service[$::apache::params::service_name],
        }
      }

      if $::phpipam::ssl_ca_certs {
        
        validate_absolute_path($::phpipam::config::ssl_config['ssl_ca'])
        
        file { $::phpipam::config::ssl_config['ssl_ca']:
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0444',
          content => $::phpipam::ssl_ca_certs,
          notify  => Service[$::apache::params::service_name],
        }
      }

      if $::phpipam::ssl_chain_certs {

        validate_absolute_path($::phpipam::config::ssl_config['ssl_chain'])

        file { $::phpipam::config::ssl_config['ssl_chain']:
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0444',
          content => $::phpipam::ssl_chain_certs,
          notify  => Service[$::apache::params::service_name],
        }
      }

    }
    else {
      $listen_port = 80
    }

    apache::vhost { 'phpipam' :
      ip                   => '*',
      port                 => $::phpipam::config::listen_port,
      servername           => $::phipam::site_fqdn,
      ip_based             => false,
      access_log_format    => 'combined',
      docroot              => "${::phpipam::apache_docroot}/phpipam",
      override             => ['All'],
      options              => ['FollowSymLinks'],
      ssl                  => $::phpipam::ssl_enabled,
      ssl_cert             => $::phpipam::config::ssl_config['ssl_cert'],
      ssl_key              => $::phpipam::config::ssl_config['ssl_key'],
      ssl_chain            => $::phpipam::config::ssl_config['ssl_chain'],
      ssl_ca               => $::phpipam::config::ssl_config['ssl_ca'],
      ssl_crl_path         => $::phpipam::config::ssl_config['ssl_crl_path'],
      ssl_crl              => $::phpipam::config::ssl_config['ssl_crl'],
      ssl_crl_check        => $::phpipam::config::ssl_config['ssl_crl_check'],
      ssl_certs_dir        => $::phpipam::config::ssl_config['ssl_certs_dir'],
      ssl_protocol         => $::phpipam::config::ssl_config['ssl_protocol'],
      ssl_cipher           => $::phpipam::config::ssl_config['ssl_cipher'],
      ssl_honorcipherorder => $::phpipam::config::ssl_config['ssl_honorcipherorder'],
      ssl_verify_client    => $::phpipam::config::ssl_config['ssl_verify_client'],
      ssl_verify_depth     => $::phpipam::config::ssl_config['ssl_verify_depth'],
      ssl_options          => $::phpipam::config::ssl_config['ssl_options'],
      ssl_proxyengine      => $::phpipam::config::ssl_config['ssl_proxyengine'],
    }
  }

  if $::phpipam::manage_mysql {
  }

  if $::phpipam::manage_php {
    ini_setting { 'php_timezone':
      ensure  => present,
      path    => '/etc/php.ini',
      section => 'Date',
      setting => 'date.timezone',
      value   => $::phpipam::php_timezone
    }
  }

  if $::phpipam::enable_pingcheck_cron {
    $pingcheck_cron_ensure = present
  }
  else {
    $pingcheck_cron_ensure = absent
  }

  cron { 'pingCheck.php':
    ensure  => $::phpipam::config::pingcheck_cron_ensure,
    command => "${::phpipam::params::php_path} ${::phpipam::apache_docroot}/phpipam/functions/scripts/pingCheck.php",
    minute  => '*/15',
    user    => 'root',
  }
}
