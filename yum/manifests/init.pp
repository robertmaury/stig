############################################################
# Class: yum
#
# Description:
# Sets up yum repositories for workstations and servers
#
# Variables:
# None
#
# Facts:
# None
#
# Files:
# yum/files/RPM-GPG-KEY-EPEL-6
# yum/files/rpmverify
# yum/files/yum.cron
#
# Templates:
# None
#
# Dependencies:
# None
############################################################
class yum {
  Yumrepo { require => File['epel-pki'] }

  yumrepo { 'epel':
      descr          => 'ELRepo.org Community Enterprise Linux Repository - el6',
      mirrorlist     => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=\$basearch',
      failovermethod => 'priority',
      enabled        => 1,
      gpgcheck       => 1,
      gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6';
  }

  file {
    '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6':
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/yum/RPM-GPG-KEY-EPEL-6',
      alias  => 'epel-pki';

    '/etc/cron.daily/yum.cron':
      # Example of how to override a location by testing variables
      #path   => $stig::yumcanary ? {
      # true    => '/etc/cron.daily/yum.cron',
      # default => '/etc/cron.weekly/yum.cron',
      #},
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
      source => 'puppet:///modules/yum/yum.cron';
  }

  augeas {
    'Ensure gpgcheck Enabled In Main Yum Configuration':
      context => '/files/etc/yum.conf',
      lens    => 'yum.lns',
      incl    => '/etc/yum.conf',
      changes => 'set main/gpgcheck 1';

    'Ensure gpgcheck Enabled For All Yum Package Repositories':
      context => '/files/etc/yum.repos.d',
      changes => "rm */*/gpgcheck[.='0']";
  }
}
