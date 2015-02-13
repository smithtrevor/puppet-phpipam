# == Class phpipam::install
#
class phpipam::install {

  package { $phpipam::package_name:
    ensure => present,
  }
}
