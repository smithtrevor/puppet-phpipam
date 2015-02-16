class phpipam::install::mysql {
  class { '::mysql::server':
    remove_default_accounts => true,
  }
}
