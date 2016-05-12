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
    $cleanpath = regsubst(regsubst($path, '\/', '_', 'G'),'_', '')
  }

  $cleanfqdn = regsubst($::fqdn, '\.', '_', 'G')
  $cleanhostname = regsubst($::hostname, '-', '_', 'G')

  $rdiff_user = 'rdiffbackup'

  #Local resources

  #create_resources('file', { "${cleanhostname}${cleanpath} ssh rdiff user ssh directory" => {
  #  ensure => directory,
  #  path   => "/var/lib/rdiff/${::fqdn}/${cleanpath}/.ssh",
  #  mode   => '0700',
  #  owner  => $rdiff_user,
  #  group  => $rdiff_user,
  #}})
  # Create ssh user key for rdiff user export and collect locally


  create_resources('sshkeys::create_key', { "${cleanfqdn}-${rdiff_user}" => {
    user        => $rdiff_user,
    home        => "/var/lib/rdiff/${::fqdn}/",
    ssh_keytype => 'rsa',
  }})

  create_resources('sshkeys::set_authorized_key', {"${rdiff_user}@${::fqdn} to ${rdiff_user}@${rdiff_server}" => {
    local_user  => $rdiff_user,
    remote_user => "${rdiff_user}@${rdiff_server}",
    home        => '/var/lib/rdiff/',
    options     => "command='rdiff-backup --server --restrict ${remote_path}/${::fqdn}'",
  }})

  cron{ "${::fqdn}${cleanpath}":
    #lint:ignore:80chars
    command => "rdiff-backup ${path} ${rdiff_user}@${rdiff_server}::${remote_path}/${::fqdn}/${cleanpath}",
    #lint:endignore
    user    => $rdiff_user,
    hour    => 1,
  }
}
