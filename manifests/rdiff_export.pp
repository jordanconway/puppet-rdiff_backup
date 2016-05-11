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


  create_resources('@@file', { "${::fqdn} ssh rdiff user directory" => {
    ensure => directory,
    path   => "/var/lib/rdiff/${::fqdn}",
    owner  => "${::fqdn}${cleanpath}",
    group  => "${::fqdn}${cleanpath}",
    tag    => $rdiffbackuptag,
  }})

  #Local resources
  # Create ssh user key for rdiff user export and collect locally

  create_resources('@@user', { "${::fqdn}${cleanpath}" => {
    ensure  => present,
    home    => "/var/lib/rdiff/${::fqdn}/${cleanpath}",
    require => [ Ssh::Client::Config::User["${::fqdn}${cleanpath}"]],
    tag    => $rdiffbackuptag,
  }})

  User <<| title == "${::fqdn}${cleanpath}" |>> { }

  ssh::client::config::user { "${::fqdn}${cleanpath}":
    ensure              => present,
    manage_user_ssh_dir => false,
    user_home_dir       => "/var/lib/rdiff/${::fqdn}/${cleanpath}",
    options             => {
      'HashKnownHosts' => 'yes'
    },
    tag                 => $rdiffbackuptag,
  }

  exec { "Create ${::fqdn}${cleanpath} user SSH key":
    path    => '/usr/bin',
    # lint:ignore:80chars
    command => "ssh-keygen -t rsa -N '' -C '${::fqdn}${cleanpath}@${::fqdn}' -f /var/lib/rdiff/${::fqdn}/${cleanpath}/.ssh/id_rsa",
    # lint:endignore
    creates => "/var/lib/rdiff/${::fqdn}/${cleanpath}/.ssh/id_rsa",
    user    => "${::fqdn}${cleanpath}",
    require => [ Ssh::Client::Config::User["${::fqdn}${cleanpath}"]],
  }

  cron{ "${::fqdn}${cleanpath}":
    #lint:ignore:80chars
    command => "rdiff-backup ${path} ${::fqdn}${cleanpath}@${rdiff_server}::/srv/rdiff/${::fqdn}/${cleanpath}",
    #lint:endignore
    user    => "${::fqdn}${cleanpath}",
    hour    => 1,
  }
}
