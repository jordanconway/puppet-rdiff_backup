# rdiff_backup::install class
class rdiff_backup::client::install(
  $package,
  $path,
  $rdiffbackuptag,
  $rdiff_server,
  $remote_path,
  $rdiff_user,
) inherits rdiff_backup::params{
  validate_string($package)


  # Install rdiff_backup and
  ensure_packages( [$package] )

  create_resources('sshkeys::create_ssh_key', { 'root' => {
    ssh_keytype => 'rsa',
  }})

  #lint:ignore:80chars
  create_resources('@@sshkeys::set_authorized_key', {"root@${::fqdn} to ${rdiff_user}@${rdiff_server}" => {
  #lint:endignore
    local_user  => $rdiff_user,
    remote_user => "root@${::fqdn}",
  #lint:ignore:80chars
    options     => "command=\"rdiff-backup --server --restrict ${remote_path}/${::fqdn}\"",
  #lint:endignore
    tag         => $rdiffbackuptag,
  }})

  create_resources('@@file', { "${remote_path}/${::fqdn}" => {
    ensure => directory,
    owner  => $rdiff_user,
    tag    => $rdiffbackuptag,
  }})


}
