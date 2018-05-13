# rdiff_backup::install class
class rdiff_backup::server::install (
  $remote_path,
  $rdiff_user,
  $rdiff_group,
  $package,
){
  validate_absolute_path($remote_path)
  validate_string($rdiff_user)
  validate_string($rdiff_group)
  validate_string($package)

  ensure_packages( [$package] )

  file { $remote_path:
    ensure => directory,
    mode   => '0700',
    owner  => $rdiff_user,
    group  => $rdiff_group,
  }

}
