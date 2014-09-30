############################################################
# Class: postfix
#
# Description:
# Configure clients' postfix installations to allow
# outgoing email to rsyslog server
#
# Variables:
# stig::mailserver
#
# Facts:
# None
#
# Files:
# None
#
# Templates:
# None
#
# Dependencies:
# None
#
############################################################
class postfix {
  package { 'postfix':
      ensure  => 'latest',
      require => Class['yum'];
  }
  
  service { 'postfix':
      ensure    => true,
      enable    => true,
      hasstatus => true,
      require   => Package['postfix'],
  }

  if !$stig::mailserver {
    augeas {
      'Disable Postfix Network Listening':
        context => '/files/etc/postfix/main.cf',
        changes => [
          'set inet_interfaces localhost',
        ];
    }
  }
  else {
    augeas {
      'Configure SMTP Greeting Banner':
        context => '/files/etc/postfix/main.cf',
        changes => "set smtpd_banner '\$myhostname ESMTP'";

      'Configure Postfix Resource Usage to Limit Denial of Service Attacks':
        context => '/files/etc/postfix/main.cf',
        changes => [
          'set default_process_limit 100',
          'set smtpd_client_connection_count_limit 10',
          'set smtpd_client_connection_rate_limit 30',
          'set queue_minfree 20971520',
          'set header_size_limit 51200',
          'set message_size_limit 10485760',
          'set smtpd_recipient_limit 100',
        ];

      # Customize and uncomment one of the following changes lines according
      # to the prose guide
      #'Configure Trusted Networks and Hosts':
      # context => '/files/etc/postfix/main.cf',
      # changes => [
      #   #'mynetworks_style subnet',
      #   #'mynetworks_style host',
      #   #"mynetworks_style '10.0.0.0/16, 192.168.1.0/24, 127.0.0.1'",
      # ];
    }

    file {
      #Ensure Security of Postfix SSL Certificates
      '/etc/pki/tls/mail':
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',

      # Customize and uncomment the following lines to automatically
      # (re)install certificate files, files are generally
      # stored in puppet/modules/postfix/files/
      #'/etc/pki/tls/mail/serverkey.pem': # private key
      # ensure => 'present',
      # owner  => 'root',
      # group  => 'root',
      # mode   => '0600',

      #'/etc/pki/tls/mail/servercert.pem': # certificate file
      # ensure => 'present',
      # owner  => 'root',
      # group  => 'root',
      # mode   => '0644',
      # source => 'puppet:///modules/postfix/servercert.pem';

      #'/etc/pki/tls/CA/cacert.pem': # CA public certificate file
      # ensure => 'present',
      # owner  => 'root',
      # group  => 'root',
      # mode   => '0644';
      # source => 'puppet:///modules/postfix/cacert.pem';
    }
  }
}
