# rdiff_backup::install class
class rdiff_backup::install(
  $package,
  $rsyncd_rsync_package,
) {
  validate_string($package)
  validate_string($rsyncd_rsync_package)

  # We need some variables out of rdiff_backup::params
  include rdiff_backup::params

  # Install rdiff_backup and rsync
  ensure_packages( [$package,$rsyncd_rsync_package] )

}
