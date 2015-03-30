############################################################
# Class: aide::install
#
# Description:
# Installs aide
#
# Variables:
# None
#
# Facts:
# None
#
# Files:
# aide/files/aide.conf
# aide/files/aide.cron
# aide/files/aidereset.cron
#
# Templates:
# None
#
# Dependencies:
# None
############################################################
class aide::install {
  # Install AIDE
  package {
    'aide':
      ensure  => latest,
      require => Class['yum'];
  }
}
