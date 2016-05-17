# rdiff_backup::install class
class rdiff_backup::client::install(
  $package,
  $rdiffbackuptag,
  $rdiff_server,
  $remote_path,
  $rdiff_user,
){
  validate_string($package)
  validate_string($rdiffbackuptag)
  validate_absolute_path($remote_path)
  validate_string($rdiff_server)
  validate_string($rdiff_user)

  # Install rdiff_backup package
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
