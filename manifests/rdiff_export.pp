#new rdiff_export
define rdiff_backup::rdiff_export (
  $ensure = undef,
  $path = undef,
  $remote_path = undef,
  $rdiff_server = undef,
  $rdiffbackuptag = undef,
  $allow = undef,
){

  if ($path) {
    $cleanpath = regsubst($path, '\/', '-', 'G')
  }

  $cleanfqdn = regsubst($::fqdn, '.', '-', 'G')

  $rdiff_user = "${cleanfqdn}${cleanpath}"

  #Local resources
  # Create ssh user key for rdiff user export and collect locally

  create_resources('@@user', { "$rdiff_user" => {
    ensure     => present,
    managehome => true,
    home       => "/var/lib/rdiff/${::fqdn}/${cleanpath}",
    tag        => $rdiffbackuptag,
  }})

  User <<| title == $rdiff_user |>> { }

  exec { "Create $rdiff_user user SSH key":
    path    => '/usr/bin',
    # lint:ignore:80chars
    command => "ssh-keygen -t rsa -N '' -C '$rdiff_user@${::fqdn}' -f /var/lib/rdiff/${::fqdn}/${cleanpath}/.ssh/id_rsa",
    # lint:endignore
    creates => "/var/lib/rdiff/${::fqdn}/${cleanpath}/.ssh/id_rsa",
    user    => $rdiff_user,
    require => User[$rdiff_user]
  }

  cron{ "${::fqdn}${cleanpath}":
    #lint:ignore:80chars
    command => "rdiff-backup ${path} ${rdiff_user}@${rdiff_server}::${remote_path}/${::fqdn}/${cleanpath}",
    #lint:endignore
    user    => $rdiff_user,
    hour    => 1,
  }
}
