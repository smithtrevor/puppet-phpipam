# == Class phpipam::params
#
# This class is meant to be called from phpipam
# It sets variables according to platform
#
class phpipam::params {
  $package_source = 'http://downloads.sourceforge.net/project/phpipam/phpipam-1.1.010.tar?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fphpipam%2Ffiles%2F%3Fsource%3Dnavbar&ts=1423856172&use_mirror=iweb'

  $apache_serveradmin = "root@${::fqdn}"

  if defined(Class['Apache']) {
    $ssl_cert      = $::apache::default_ssl_cert
    $ssl_key       = $::apache::default_ssl_key
    $ssl_chain     = $::apache::default_ssl_chain
    $ssl_ca        = $::apache::default_ssl_ca
    $ssl_crl_path  = $::apache::default_ssl_crl_path
    $ssl_crl       = $::apache::default_ssl_crl
    $ssl_certs_dir = $::apache::params::ssl_certs_dir
  } else {
    $ssl_cert      = undef
    $ssl_key       = undef
    $ssl_chain     = undef
    $ssl_ca        = undef
    $ssl_crl_path  = undef
    $ssl_crl       = undef
    $ssl_certs_dir = undef
  }

  $ssl_params_hash = {
    'ssl_cert'             => $ssl_cert,
    'ssl_key'              => $ssl_key,
    'ssl_chain'            => $ssl_chain,
    'ssl_ca'               => $ssl_ca,
    'ssl_crl_path'         => $ssl_crl_path,
    'ssl_crl'              => $ssl_crl,
    'ssl_certs_dir'        => $ssl_certs_dir,
    'ssl_protocol'         => undef,
    'ssl_cipher'           => undef,
    'ssl_honorcipherorder' => undef,
    'ssl_verify_client'    => undef,
    'ssl_verify_depth'     => undef,
    'ssl_options'          => undef,
    'ssl_proxyengine'      => undef,
  }

  case $::osfamily {
    'RedHat', 'Amazon': {
      $apache_docroot = '/var/www/html'
      $apache_user = 'apache'
      $apache_group = 'apache'
      $apache_server_root = '/etc/httpd'
      $php_packages = [   'php-pear',
                          'php-pear-MDB2-Driver-mysqli',
                          'php-cli',
                          'php-mcrypt',
                          'php-ldap',
                          'php-gd',
      ]
      $php_path = '/usr/bin/php'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
