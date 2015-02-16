class phpipam::install::mysql {
  class { '::mysql':
    remove_default_accounts => true,
  }
}
