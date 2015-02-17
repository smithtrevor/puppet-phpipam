# == Class phpipam::config
#
# This class is called from phpipam
#
class phpipam::config {

  if $::phpipam::manage_apache {
    
    apache::vhost { 'phpipam' :
      ip                => '*',
      port              => '80',
      servername        => $::phipam::site_fqdn,
      ip_based          => false,
      access_log_format => 'combined',
      docroot           => "${::phpipam::apache_docroot}/phpipam",
      override          => ['All'],
      options           => ['FollowSymLinks'],
      ssl               => $::phpipam::ssl_enabled,
    }
  }

  if $::phpipam::manage_mysql {
  }

  if $::phpipam::manage_php {
    ini_setting { "php_timezone":
      ensure  => present,
      path    => '/etc/php.ini',
      section => 'Date',
      setting => 'date.timezone',
      value   => $::phpipam::php_timezone
    }
  }
}
