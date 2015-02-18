class phpipam::install::mysql {

   if $caller_module_name != $module_name {
      fail("Use of private class ${name} by ${caller_module_name}")
    }

  class { '::mysql::server':
    remove_default_accounts => true,
    root_password           => $::phpipam::mysql_root_password,
  }
}
