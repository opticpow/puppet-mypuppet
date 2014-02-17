node default {
    include screen
    include localrepo
    include domain
    include bash

    class { 'sudo': }
    sudo::conf{ 'admins':
      priority => 10,
      content  => "%wheel ALL=(ALL) NOPASSWD: ALL",
    }
}

node styx inherits default {
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

