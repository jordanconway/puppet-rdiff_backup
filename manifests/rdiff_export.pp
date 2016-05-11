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

  #Local resources
  # Create ssh user key for rdiff user export and collect locally

  create_resources('@@user', { "${::hostname}${cleanpath}" => {
    ensure     => present,
    managehome => true,
    home       => "/var/lib/rdiff/${::fqdn}/${cleanpath}",
    tag        => $rdiffbackuptag,
  }})

  create_resources('@@file', { "${::fqdn}${cleanpath} ssh rdiff user directory" => {
    ensure => directory,
    path   => "/var/lib/rdiff/${::fqdn}/${cleanpath}/.ssh",
		mode   => '0700',
    owner  => "${::hostname}${cleanpath}",
    group  => "${::hostname}${cleanpath}",
    tag    => $rdiffbackuptag,
  }})


  User <<| title == "${::fqdn}${cleanpath}" |>> { }

  exec { "Create ${::hostname}${cleanpath} user SSH key":
    path    => '/usr/bin',
    # lint:ignore:80chars
    command => "ssh-keygen -t rsa -N '' -C '${::hostname}${cleanpath}@${::fqdn}' -f /var/lib/rdiff/${::fqdn}/${cleanpath}/.ssh/id_rsa",
    # lint:endignore
    creates => "/var/lib/rdiff/${::fqdn}/${cleanpath}/.ssh/id_rsa",
    user    => "${::hostname}${cleanpath}",
  }

  cron{ "${::fqdn}${cleanpath}":
    #lint:ignore:80chars
    command => "rdiff-backup ${path} ${::hostname}${cleanpath}@${rdiff_server}::${remote_path}/${::fqdn}/${cleanpath}",
    #lint:endignore
    user    => "${::hostname}${cleanpath}",
    hour    => 1,
  }
}
