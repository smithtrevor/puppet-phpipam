# == Class: phpipam
#
# Full description of class phpipam here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class phpipam (
  $package_name = $phpipam::params::package_name,
  $service_name = $phpipam::params::service_name,
) inherits phpipam::params {

  # validate parameters here

  class { 'phpipam::install': } ->
  class { 'phpipam::config': } ~>
  class { 'phpipam::service': } ->
  Class['phpipam']
}
