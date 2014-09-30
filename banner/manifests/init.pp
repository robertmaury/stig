############################################################
# Class: banner
#
# Description:
# Provides consistent banner across all boxes
#
# Variables:
# stig::server
#
# Facts:
# None
#
# Files:
# banner/files/issue
# banner/files/custom.conf
#
# Templates:
# None
#
# Dependencies:
# None
############################################################
class banner {
  file {
    '/etc/issue':
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0444',
      source => 'puppet:///modules/banner/issue',
  }

  # We don't run X on our servers
  if !$stig::server {
    include banner::gdm
  }
}

# This should most likely be parsed conditionally in the init,
# pulling gdm conditionals out into their own file.  Maybe on
# Second run?
class banner::gdm {
  file {
    '/etc/gdm/custom.conf':
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0444',
      source => 'puppet:///modules/banner/custom.conf';

    '/var/lib/gdm/.gconf/apps/gdm/simple-greeter/%gconf.xml':
      ensure => 'present',
      owner  => 'gdm',
      group  => 'gdm',
      mode   => '0600',
      source => 'puppet:///modules/banner/%gconf.xml';
    [
      '/var/lib/gdm/.gconf/apps/gdm/simple-greeter',
      '/var/lib/gdm/.gconf/apps/gdm/',
      '/var/lib/gdm/.gconf/apps/',
    ]:
      ensure => directory;
    [
      '/var/lib/gdm/.gconf/apps/gdm/%gconf.xml',
      '/var/lib/gdm/.gconf/apps/%gconf.xml',
    ]:
      ensure => present;
  }
}
