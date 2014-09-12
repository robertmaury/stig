class stig ( $server          = false,
             $dnsserver       = false,
             $ftpserver       = false,
             $webserver       = false,
             $gitserver       = false,
             $krbserver       = false,
             $ldapserver      = false,
             $mailserver      = false,
             $needs_gnome     = false,
             $needs_x11       = false,
             $nfsbackupserver = false,
             $nfsserver       = false,
             $puppetserver    = false,
             $syslogserver    = false,
             $yumcanary       = false ) {

     $dnsservers = "8.8.8.8"
     $gateway = "10.20.1.1"
     $syslogserver_ip = "127.0.0.1"
     $domain = ""

     $sudoers = "%admins  ALL=(ALL)       ALL"

#     class { "fstab": }
     class { "init": }
     class { "iptables": }
     class { "kernel": }
#     class { "named": }
#     class { "networking": }
#     class { "nfs": nfs_server_fqdn => $nfs_server_fqdn; }
     class { "ntp": }
     class { "packages": }
     class { "pam": }
     class { "postfix": }
#     class { "puppet": }
     class { "rsyslog": }
     class { "services": }
     class { "ssh": }
     class { "sudo": }
     class { "sysctl": }
     class { "yum": }

}
