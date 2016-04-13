# rdiff_backup::params class
class rdiff_backup::params {

  $rsyncd_rsync_package = 'rsync'
  $rsyncd_xinetd_package = 'xinetd'
  $rsyncd_xinetd_service = 'xinetd'
  $ensure = 'present'
  $chroot = true
  $readonly = true
  $mungesymlinks = true
  $path = undef
  $uid = undef
  $gid = undef
  $users = undef
  $secrets = undef
  $allow = undef
  $deny = undef
  $prexferexec = undef
  $postxferexec = undef
  $rdiffbackuptag = 'rdiffbackuptag'

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
