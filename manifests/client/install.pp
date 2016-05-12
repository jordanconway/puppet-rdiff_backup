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
  
  create_resources('sshkeys::create_ssh_key', { $rdiff_user => {
    ssh_keytype => 'rsa',
  }})

  create_resources('@@sshkeys::set_authorized_key', {"${rdiff_user}@${::fqdn} to ${rdiff_user}@${rdiff_server}" => {
    local_user  => $rdiff_user,
    remote_user => "${rdiff_user}@${::fqdn}}",
    options     => "command=\"rdiff-backup --server --restrict ${remote_path}/${::fqdn}\"",
    tag         => $rdiffbackuptag,
  }})

  create_resources('@@file', { "${remote_path}/${::fqdn}" => {
    ensure => directory,
    owner  => $rdiff_user,
    tag    => $rdiffbackuptag,
  }})


}
