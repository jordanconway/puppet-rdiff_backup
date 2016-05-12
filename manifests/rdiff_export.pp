#new rdiff_export
define rdiff_backup::rdiff_export (
  $ensure = undef,
  $path = undef,
  $remote_path = undef,
  $rdiff_server = undef,
  $rdiffbackuptag = undef,
  $allow = undef,
  $rdiff_user = undef,
){

  if ($path) {
    $cleanpath = regsubst(regsubst($path, '\/', '_', 'G'),'_', '')
  }

  $cleanfqdn = regsubst($::fqdn, '\.', '_', 'G')
  $cleanhostname = regsubst($::hostname, '-', '_', 'G')

  cron{ "${::fqdn}${cleanpath}":
    #lint:ignore:80chars
    command => "rdiff-backup ${path} ${rdiff_user}@${rdiff_server}::${remote_path}/${::fqdn}/${cleanpath}",
    #lint:endignore
    user    => $rdiff_user,
    hour    => 1,
  }

  create_resources('@@file', { "${remote_path}/${::fqdn}" => {
    ensure => directory,
    owner  => $rdiff_user,
  }})
}
