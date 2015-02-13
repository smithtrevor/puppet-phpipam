# == Class phpipam::install
#
class phpipam::install {

  $phpipam::install::phpipam_docroot = "${::phpipam::apache_docroot}/phpipam"

  class { 'staging':
    path  => '/tmp',
    owner => 'puppet',
    group => 'puppet',
  }

  staging::file { 'phpipam_tar':
    source  => $::phpipam::package_source,
    require => File[$::phpipam::apache_docroot],
  }

  staging::extract { 'phpipam_docroot':
    target  => $::phpipam::apache_docroot,
    creates => "${::phpipam::apache_docroot}/phpipam",
    require => Staging::File['phpipam_tar'],
  }

  file { $::phpipam::apache_docroot:
    ensure => directory,
    owner  => 'root',
    group  => $::phpipam::apache_group,
    mode   => '0750',
  }

}
