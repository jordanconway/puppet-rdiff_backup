#   class rdiff_backup::user
class rdiff_backup::client::user(
  $rdiff_user = $rdiff_backup::params::rdiff_user,
) inherits rdiff_backup::params {

  create_resources('user', { $rdiff_user => {
    ensure     => present,
    managehome => true,
    home       => '/var/lib/rdiff/',
  }})
}
