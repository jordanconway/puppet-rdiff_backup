#new rdiff_export
define rdiff_backup::rdiff_export (
  $ensure,
  $chroot,
  $readonly,
  $mungesymlinks,
  $path,
  $uid,
  $gid,
  $users,
  $secrets,
  $deny,
  $prexferexec,
  $postxferexec,
  $remote_path,
  $rdiff_server,
  $rdiffbackuptag,
  $allow = $::ipaddress,
){

  include rsyncd

  create_resources('@@rsyncd::export', {"${::fqdn}_${$path}" => {
    ensure        => $ensure,
    chroot        => $chroot,
    readonly      => $readonly,
    mungesymlinks => $mungesymlinks,
    path          => $remote_path,
    uid           => $uid,
    gid           => $gid,
    users         => $users,
    secrets       => $secrets,
    allow         => $allow,
    deny          => $deny,
    prexferexec   => $prexferexec,
    postxferexec  => $postxferexec,
    tag           => $rdiffbackuptag
  }})

  create_resources('@@file', { "${::fqdn}_${path}" => {
    ensure => directory,
    path   => $remote_path,
    owner  => $uid,
    group  => $gid,
    tag    => $rdiffbackuptag,
  }})

  cron{ "${::fqdn}_${path}":
    command => "rdiff-backup ${path} ${gid}@${rdiff_server}::${remote_path}",
    user    => $uid,
    hour    => 1,
  }
}
