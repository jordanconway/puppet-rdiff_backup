# rdiff_backup::params class
class rdiff_backup::params {

  $rsyncd_rsync_package = 'rsync'
  $rsyncd_xinetd_package = 'xinetd'
  $rsyncd_xinetd_service = 'xinetd'
  $ensure = undef
  $chroot = undef
  $readonly = undef
  $mungesymlinks = undef
  $path = undef
  $uid = undef
  $gid = undef
  $users = undef
  $secrets = undef
  $allow = undef
  $deny = undef
  $prexferexec = undef
  $postxferexec = undef
  $remote_path = undef
  $rdiff_server = undef
  $rdiffbackuptag = $::fqdn

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
