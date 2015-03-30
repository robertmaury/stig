############################################################
# Class: audit::install
#
# Description:
# This will install the auditd service
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
class audit::install {
  package {
    'audit':
      ensure  => 'latest',
      require => Class['yum'],
  }
}
