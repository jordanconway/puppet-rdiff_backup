#   class rdiff_backup::server::user
class rdiff_backup::server::user(
  $rdiff_user,
  $rdiff_group = "root",
){
  validate_string($rdiff_user)

  create_resources('file', {'/var/lib/rdiff' => {
    ensure => directory,
    owner  => $rdiff_user,
    group  => $rdiff_group,
    mode   => '0700',
  }})

  create_resources('user', { $rdiff_user => {
    ensure     => present,
    managehome => true,
    home       => '/var/lib/rdiff/',
  }})
}
