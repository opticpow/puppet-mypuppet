node default {
  notify { "!!! NO HOST ENTRY FOUND. PLEASE UPDATE NODES.PP WITH THIS NODE TYPE !!!": }
}

node unix_default {
    include screen
    include localrepo
    include domain

    class { 'sudo':
      priority => 10,
      content  => "%wheel ALL=(ALL) NOPASSWD: ALL",
    }
}

node styx inherits unix_default {
  class { 'puppet':
    mode => 'server',
    server => 'styx.ingram.internal',
    dns_alt_names => 'styx.ingram.internal,styx,puppet',
    #prerun_command => 'r10k deploy environment -p',
    module_path => '/etc/puppet/environments/$environment/modules',
    manifest_path => '/etc/puppet/environments/$environment/manifests/site.pp',
    passenger => true,
    environment => 'master',
    runmode => 'manual',
  }

  file {
    '/etc/puppet/environments/':
      ensure => 'directory';

    '/var/cache/r10k':
      ensure => 'directory';
  }

   package { 'git':
     ensure => 'present'
  }

  class { 'hiera':
    hierarchy    => [
      'common'],
  } 

  #apache::vhost { 'default':
  #  docroot     => '/var/www/document_root',
  #  server_name => false,
  #  priority    => '',
  #  template    => 'apache/virtualhost/vhost.conf.erb',
  #}
}

