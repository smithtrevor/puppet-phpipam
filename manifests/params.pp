# == Class phpipam::params
#
# This class is meant to be called from phpipam
# It sets variables according to platform
#
class phpipam::params {
  $package_source = 'http://downloads.sourceforge.net/project/phpipam/phpipam-1.1.010.tar?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fphpipam%2Ffiles%2F%3Fsource%3Dnavbar&ts=1423856172&use_mirror=iweb'

  $apache_serveradmin = "root@${::fqdn}"
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
                          'php-ldap'
      ]
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
