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
      ssl               => false,
      ip_based          => false,
      access_log_format => 'combined',
      docroot           => "${::phpipam::apache_docroot}/phpipam",
    }
  }

  if $::phpipam::manage_mysql {
  }

}
