# == Class phpipam::params
#
# This class is meant to be called from phpipam
# It sets variables according to platform
#
class phpipam::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'phpipam'
      $service_name = 'phpipam'
    }
    'RedHat', 'Amazon': {
      $package_name = 'phpipam'
      $service_name = 'phpipam'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
