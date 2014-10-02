############################################################
# Class: audit::config
#
# Description:
# This will configure the auditd service
#
# Variables:
# None
#
# Facts:
# architecture -> used to select the appropiate rules for the system
#
# Files:
# audit/files/audit.rules.x86_64
# audit/files/audit.rules.i386
#
# Templates:
# None
#
# Dependencies:
# None
############################################################
class audit::config {

  # Make sure the audit log is present and owned properly
  file {
    '/var/log/audit/audit.log':
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0600';
  }

  # Make sure the audit.rules file exists, is owned properly, and
  # is placed based on architecture of the system
  file {
    '/etc/audit/audit.rules':
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0640',
      notify => Service['auditd'],
      source => "puppet:///modules/audit/audit.rules.${::architecture}";
  }

  # Values come from suggested settings in prose guide,
  # see man auditd.conf for more options, requires simplevars.lns
  augeas {
    'Configure auditd log_file File Name':
      context => '/files/etc/audit/auditd.conf',
      lens    => 'simplevars.lns',
      incl    => '/etc/audit/auditd.conf',
      changes => 'set log_file /var/log/audit/audit.log';

    'Configure auditd Number of Logs Retained':
      context => '/files/etc/audit/auditd.conf',
      lens    => 'simplevars.lns',
      incl    => '/etc/audit/auditd.conf',
      changes => 'set num_logs 5';

    'Configure auditd Max Log File Size':
      context => '/files/etc/audit/auditd.conf',
      lens    => 'simplevars.lns',
      incl    => '/etc/audit/auditd.conf',
      changes => 'set max_log_file 6';

    'Configure auditd max_log_file_action Upon Reaching Maximum Log Size':
      context => '/files/etc/audit/auditd.conf',
      lens    => 'simplevars.lns',
      incl    => '/etc/audit/auditd.conf',
      changes => 'set max_log_file_action rotate';

    'Configure auditd space_left Action on Low Disk Space':
      context => '/files/etc/audit/auditd.conf',
      lens    => 'simplevars.lns',
      incl    => '/etc/audit/auditd.conf',
      changes => 'set space_left_action email';

    'Configure auditd admin_space_left Action on Low Disk Space':
      context => '/files/etc/audit/auditd.conf',
      lens    => 'simplevars.lns',
      incl    => '/etc/audit/auditd.conf',
      changes => 'set admin_space_left_action single';

    'Configure auditd mail_acct Action on Low Disk Space':
      context => '/files/etc/audit/auditd.conf',
      lens    => 'simplevars.lns',
      incl    => '/etc/audit/auditd.conf',
      changes => 'set action_mail_acct root';

    'Configure auditd to use audispd plugin':
      context => '/files/etc/audisp/plugins.d/syslog.conf',
      lens    => 'simplevars.lns',
      incl    => '/etc/audisp/plugins.d/syslog.conf',
      changes => 'set active yes',
      notify  => Service['auditd'];

    'Configure auditd disk_full_action Action on Audit Storage Full':
      context => '/files/etc/audit/auditd.conf',
      lens    => 'simplevars.lns',
      incl    => '/etc/audit/auditd.conf',
      changes => 'set disk_full_action syslog';

    'Configure auditd disk_error_action Action on Disk Errors':
      context => '/files/etc/audit/auditd.conf',
      lens    => 'simplevars.lns',
      incl    => '/etc/audit/auditd.conf',
      changes => 'set disk_error_action syslog';
  }
}
