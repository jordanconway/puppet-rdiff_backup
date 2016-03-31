# rdiff_backup::params class
class rdiff_backup::params {

  $rsyncd_rsync_package = 'rsync'
  $rsyncd_xinetd_package = 'xinetd'
  $rsyncd_xinetd_service = 'xinetd'
  $rsyncd_export_ensure = present
  $rsyncd_export_chroot = true
  $rsyncd_export_readonly = true
  $rsyncd_export_mungesymlinks = true
  $rsyncd_export_path = undef
  $rsyncd_export_uid = undef
  $rsyncd_export_gid = undef
  $rsyncd_export_users = undef
  $rsyncd_export_secrets = undef
  $rsyncd_export_allow = undef
  $rsyncd_export_deny = undef
  $rsyncd_export_prexferexec = undef
  $rsyncd_export_postxferexec = undef

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
