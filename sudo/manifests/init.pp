############################################################
# Class: sudo
#
# Description:
# This file sets up the sudoers file for an admin group
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
class sudo {
  file {
    '/etc/sudoers.d/sudogroup':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      content => template('sudo/sudoers.erb'),
  }
}
