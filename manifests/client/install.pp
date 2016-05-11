# rdiff_backup::install class
class rdiff_backup::client::install(
  $package,
  $path,
) {
  validate_string($package)

  # We need some variables out of rdiff_backup::params
  include rdiff_backup::params

  # Install rdiff_backup and
  ensure_packages( [$package] )

  create_resources('file', {['/var/lib/rdiff',"/var/lib/rdiff/${::fqdn}"] => {
    ensure => directory,
  }})

  if ($path) {
    $cleanpath = regsubst($path, '\/', '-', 'G')
  }

  $cleanfqdn = regsubst($::fqdn, '.', '-', 'G')

  $rdiff_user = "${cleanfqdn}${cleanpath}"

  #Local resources
  # Create ssh user key for rdiff user export and collect locally

  create_resources('file', { "${rdiff_user} ssh rdiff user directory" => {
    ensure => directory,
    path   => "/var/lib/rdiff/${::fqdn}/${cleanpath}",
    mode   => '0700',
    owner  => $rdiff_user,
    group  => $rdiff_user,
  }})
  create_resources('file', { "${rdiff_user} ssh rdiff user ssh directory" => {
    ensure => directory,
    path   => "/var/lib/rdiff/${::fqdn}/${cleanpath}/.ssh",
    mode   => '0700',
    owner  => $rdiff_user,
    group  => $rdiff_user,
  }})
}
