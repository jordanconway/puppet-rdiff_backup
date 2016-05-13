#   class rdiff_backup::server::user
class rdiff_backup::server::user(
  $rdiff_user = $rdiff_backup::params::rdiff_user,
) inherits rdiff_backup::params {

  create_resources('file', {'/var/lib/rdiff' => {
    ensure => directory,
  }})
  
  create_resources('user', { $rdiff_user => {
    ensure     => present,
    managehome => true,
    home       => '/var/lib/rdiff/',
  }})
}
