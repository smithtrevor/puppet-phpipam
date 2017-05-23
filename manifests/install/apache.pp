# install apache and php
class phpipam::install::apache {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  class { '::apache':
    default_vhost          => false,
    server_tokens          => 'ProductOnly',
    server_signature       => 'Off',
    serveradmin            => $::phpipam::apache_serveradmin,
    server_root            => $::phpipam::apache_server_root,
    keepalive              => 'Off',
    max_keepalive_requests => '500',
    keepalive_timeout      => '15',
    mpm_module             => false,
    trace_enable           => 'Off',
    vhost_dir              => '/etc/httpd/vhosts.d',
  }

  class { '::apache::mod::prefork': }
  -> class { '::apache::mod::php': }

}
