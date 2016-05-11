# rdiff_backup::install class
class rdiff_backup::client::install(
  $package,
) {
  validate_string($package)

  # We need some variables out of rdiff_backup::params
  include rdiff_backup::params

  # Install rdiff_backup and
  ensure_packages( [$package] )

}
