# == Class phpipam::config
#
# This class is called from phpipam
#
class phpipam::config {

  if $::phpipam::manage_apache {

    if $::phpipam::ssl_enabled {
      $listen_port = 443

      $ssl_config = deep_merge($::phpipam::params::ssl_params_hash, $::phpipam::ssl_options)
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
}
