############################################################
# Class: aide
#
# Description:
# Installs and configures aide, and disables prelinking
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
class aide {
  include aide::config
  include aide::install
}
