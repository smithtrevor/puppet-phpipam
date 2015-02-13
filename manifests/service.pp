# == Class phpipam::service
#
# This class is meant to be called from phpipam
# It ensure the service is running
#
class phpipam::service {

  service { $phpipam::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
