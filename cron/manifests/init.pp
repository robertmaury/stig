############################################################
# Class: cron
#
# Description:
# - This will configure workstations to run puppet at a randomly
# determined interval.
# - It will configure machines to check RPM permissions once a week.
# - It will configure machines to check for SUID and SGID binaries
# once a week.
#
# Variables:
# stig::puppetserver
# stig::server
# checkkernelversion
# first
# second
# puppetcron
#
# Facts:
# fqdn
#
# Files:
# cron/files/check_kernel_version
# cron/files/rpmverify
# cron/files/suidsgidcheck
#
# Templates:
# cron/templates/crontab.erb
#
# Dependencies:
# None
############################################################
class cron {

  # This is an example of how to set up a unique run time for puppet
  # agent on each workstation. The resulting cron line is invoked in
  # modules/cron/templates/crontab.erb

  $first = fqdn_rand(30)
  $second = $first + 30

  $puppetcron = "${first},${second} * * * * root /usr/bin/puppet agent --test > /dev/null 2>&1"

  file {
    '/etc/cron.deny':
      ensure  => 'absent';

    '/etc/at.deny':
      ensure  => 'absent';

    '/etc/cron.allow':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => 'root\n';

    '/etc/crontab':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('cron/crontab.erb');

    '/etc/cron.d':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      recurse => true;

    '/etc/cron.weekly/rpmverify':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      source  => 'puppet:///modules/cron/rpmverify';

    '/etc/cron.weekly/suidsgidcheck':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      source  => 'puppet:///modules/cron/suidsgidcheck';
  }
}
