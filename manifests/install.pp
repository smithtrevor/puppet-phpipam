# == Class phpipam::install
#
class phpipam::install {

  $phpipam_docroot = "${::phpipam::apache_docroot}/phpipam"
  
  if $::phpipam::manage_apache {

    contain phpipam::install::apache
  }

  if $::phpipam::manage_php {
    package { $::phpipam::params::php_packages:
      ensure => 'present',
    }

  }

  class { 'staging':
    path  => '/tmp',
    owner => 'puppet',
    group => 'puppet',
  }

  staging::file { 'phpipam.tar':
    source  => $::phpipam::package_source,
    require => File[$::phpipam::apache_docroot],
  }

  staging::extract { 'phpipam.tar':
    target  => $::phpipam::apache_docroot,
    creates => "${::phpipam::apache_docroot}/phpipam",
    require => Staging::File['phpipam.tar'],
  }

  file { $::phpipam::install::phpipam_docroot:
    owner     => 'root',
    group     => $::phpipam::apache_group,
    mode      => '0640',
    recurse   => true,
    subscribe => Staging::Extract[ 'phpipam.tar'],
  }

  file { $::phpipam::apache_docroot:
    ensure  => directory,
    owner   => 'root',
    group   => $::phpipam::apache_group,
    mode    => '0750',
    require => Group[$::phpipam::apache_group],
  }

}
