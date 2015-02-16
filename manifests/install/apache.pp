class phpipam::install::apache {
  
  class { 'apache':
    default_vhost         => false,
    server_tokens         => 'ProductOnly',
    server_signature      => 'Off',
    serveradmin           => $::phpipam::apache_serveradmin,
    server_root           => $::phpipam::apache_server_root,
    keepalive             => 'Off',
    max_keepalive_requess => '500',
    keepalive_timeoute    => '15',
    mpm_module            => false,
    trace_enable          => 'Off',
    vhost_dir             => '/etc/httpd/vhosts.d'
  }

}
