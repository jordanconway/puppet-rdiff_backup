# rdiff_backup::params class
class rdiff_backup::params {

  case $::osfamily {
    'RedHat': {
      $package = 'rdiff-backup'
    }
    'Debian': {
      $package = 'rdiff-backup'
    }
    default: {
    }
  }
}
