############################################################
# Class: audit::service
#
# Description:
# This will run the auditd service
#
# Variables:
# None
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
############################################################
class audit::service {
  service {
    'auditd':
      ensure    => 'running',
      enable    => true,
      hasstatus => true,
      require   => Package['audit'],
  }
}
