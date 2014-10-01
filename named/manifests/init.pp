############################################################
# Class: named
#
# Description:
# Provide dns server support (zones are managed outside of puppet)
#
# Variables:
# stig::dnsserver
#
# Facts:
# None
#
# Files:
# named/files/named.conf
# named/files/named.initd
# named/files/named.sysconfig
#
# Templates:
# None
#
# Dependencies:
# None
############################################################
class named {
  if $stig::dnsserver {
    class { 'named::server': }
  }
  else {
    package {
      [
        'bind',
        'bind-chroot',
      ]:
        ensure  => absent,
        require => Class['yum'];
    }

    service {
      'named':
        ensure    => false,
        enable    => false,
        hasstatus => true;
    }
  }
}

# Named server class.  
# TODO: Pull out into its own class
class named::server {
  package {
    [
      'bind-chroot',
    ]:
      ensure  => 'latest',
      require => Class['yum'];
  }

  service {
    'named':
      ensure    => true,
      enable    => true,
      hasstatus => true,
      require   => Package['bind-chroot'];
  }

  file {
    [
      '/etc/pki/dnssec-keys',
      '/var/named/chroot',
      '/var/named/chroot/dev',
      '/var/named/chroot/etc',
      '/var/named/chroot/etc/keys',
      '/var/named/chroot/etc/named',
      '/var/named/chroot/usr/',
      '/var/named/chroot/usr/lib64',
      '/var/named/chroot/var',
      '/var/named/chroot/var/run',
    ]:
      ensure  => 'directory',
      owner   => 'root',
      group   => 'named',
      mode    => '0750';
    [
      '/var/named/chroot/var/log',
      '/var/named/chroot/var/tmp',
      '/var/named/chroot/var/run/named',
    ]:
      ensure  => 'directory',
      owner   => 'named',
      group   => 'named',
      mode    => '0770';
    '/var/named/chroot/usr/lib64/bind':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0755';
    # This can be uncommented after named.conf is 
    # created and placed in the named-files directory
    # '/etc/named.conf':
    # owner   => 'root',
    # group   => 'named',
    # mode    => '0640',
    # source  => 'puppet:///modules/named/named.conf';
    '/etc/sysconfig/named':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/named/named.sysconfig';
    '/etc/init.d/named':
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => 'puppet:///modules/named/named.initd';
  }
}
