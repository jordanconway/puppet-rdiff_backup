# rdiff_backup::install class
class rdiff_backup::client::install(
  $package,
  $path,
	$rdiffbackuptag,
) {
  validate_string($package)

  # We need some variables out of rdiff_backup::params
  include rdiff_backup::params

  # Install rdiff_backup and
  ensure_packages( [$package] )

  create_resources('@@file', {['/var/lib/rdiff',"/var/lib/rdiff/${::fqdn}"] => {
    ensure => directory,
		tag    => $rdiffbackuptag,
  }})

  File <<| title == ['/var/lib/rdiff',"/var/lib/rdiff/${::fqdn}"] |>> { }

}
