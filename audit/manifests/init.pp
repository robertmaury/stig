############################################################
# Class: audit
#
# Description:
# This will install, configure, and run the auditd service
#
# Variables:
# None
#
# Facts:
# architecture -> used to select the appropiate rules for the system
#
# Files:
# audit/files/audit.rules.x64
# audit/files/audit.rules.x86
#
# Templates:
# None
#
# Dependencies:
# None
############################################################
class audit {
  include audit::config
  include audit::install
  include audit::service
}
