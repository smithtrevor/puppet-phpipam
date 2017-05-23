# == Class: phpipam
#
# Full description of class phpipam here.
#
#
class phpipam (
  # lint:ignore:140chars
  $apache_docroot         = $::phpipam::params::apache_docroot,         # document root for apache this is the parent directory to the phpipam docroot
  $apache_user            = $::phpipam::params::apache_user,            # user account under which the httpd processes run
  $apache_group           = $::phpipam::params::apache_group,           # group account for the apache_user
  $package_source         = $::phpipam::params::package_source,         # source url for the phpipam archive
  $manage_apache          = true,                                       # boolean flag for enabling this module to manage apache
  $manage_php             = true,                                       # boolean flag for enabling this module to manage php
  $manage_mysql           = true,                                       # boolean flag for enabling this module to manage mysql
  $apache_server_root     = $::phpipam::params::apache_server_root,     # the root directory for the httpd configuration files
  $apache_serveradmin     = $::phpipam::params::apache_serveradmin,     # serveradmin value as set in the vhost configuration
  $mysql_root_password    = 'strongpassword',                           # root password for the mysql installation
  $php_timezone           = $::timezone,                                # configures date.timezone in php.ini
  $site_fqdn              = $::fqdn,                                    # fully qualified domain name for the web site
  $ssl_certificate        = false,                                      # contains the ssl cert for https, false defaults to a self signed cert
  $ssl_key                = false,                                      # contains the ssl key for https, false defaults to a locally generated key
  $ssl_ca_certs           = false,                                      # contains the CA cert, false works with the self signed cert
  $ssl_chain_certs        = false,                                      # contains the chain cert, false works with the self signed cert
  $ssl_enabled            = false,                                      # boolean that when true sets the site to run under https
  $enable_pingcheck_cron  = true,                                       # boolean that adds the pingCheck.php cronjob to the root user
  $ssl_options            = {},                                         # hash of that allows overrides of the default ssl settings, see params.pp
  # lint:endignore
) inherits phpipam::params {

  if $::osfamily == 'Redhat' {
  # validate parameters here
  validate_absolute_path( $apache_docroot,
                          $apache_server_root,
  )
  validate_string($apache_user,
                  $apache_group,
                  $apache_serveradmin,
                  $php_timezone,
  )
  validate_hash($ssl_options)
  validate_bool(  $manage_apache,
                  $manage_php,
                  $manage_mysql,
                  $enable_pingcheck_cron,
  )

  class { '::phpipam::install': }
  -> class { '::phpipam::config': }
  ~> class { '::phpipam::service': }
  -> Class['phpipam']

  }
  else {
    fail("${::osfamily} not supported")
  }
}
