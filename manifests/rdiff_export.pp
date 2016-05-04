#new rdiff_export
define rdiff_backup::rdiff_export (
  $ensure = undef,
  $chroot = undef,
  $readonly = undef,
  $mungesymlinks = undef,
  $path = undef,
  $uid = undef,
  $gid = undef,
  $users = undef,
  $secrets = undef,
  $deny = undef,
  $prexferexec = undef,
  $postxferexec = undef,
  $remote_path = undef,
  $rdiff_server = undef,
  $rdiffbackuptag = undef,
  $allow = undef,
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
