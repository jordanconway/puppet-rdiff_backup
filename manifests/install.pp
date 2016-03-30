# rdiff_backup::install class
class rdiff_backup::install(
  $package,
  $rsyncd_export_ensure,
  $rsyncd_export_chroot,
  $rsyncd_export_readonly,
  $rsyncd_export_mungesymlinks,
  $rsyncd_export_path,
  $rsyncd_export_uid,
  $rsyncd_export_gid,
  $rsyncd_export_users,
  $rsyncd_export_secrets,
  $rsyncd_export_allow,
  $rsyncd_export_deny,
  $rsyncd_export_prexferexec,
  $rsyncd_export_postxferexec,
) {
  validate_string($package)
  validate_string($rsyncd_export_ensure)
  validate_string($rsyncd_export_chroot)
  validate_string($rsyncd_export_readonly)
  validate_string($rsyncd_export_mungesymlinks)
  validate_string($rsyncd_export_path)
  validate_string($rsyncd_export_uid)
  validate_string($rsyncd_export_gid)
  validate_string($rsyncd_export_users)
  validate_string($rsyncd_export_secrets)
  validate_string($rsyncd_export_allow)
  validate_string($rsyncd_export_deny)
  validate_string($rsyncd_export_prexferexec)
  validate_string($rsyncd_export_postxferexec)

  # We need some variables out of rdiff_backup::params
  include rdiff_backup::params

  # Install rdiff_backup
  package { $rdiff_backup::params::package:
    ensure => present,
  }


}
