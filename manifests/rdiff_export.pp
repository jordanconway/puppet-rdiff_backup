#new rdiff_export
define rdiff_backup::rdiff_export (
  $ensure=present,
  $chroot=true,
  $readonly=true,
  $mungesymlinks=true,
  $path=undef,
  $uid=undef,
  $gid=undef,
  $users=undef,
  $secrets=undef,
  $allow=undef,
  $deny=undef,
  $prexferexec=undef,
  $postxferexec=undef,
  $remote_path=undef,
  $rdiff_server=undef,
  $rdiff_name=$title,
  $rdiffbackuptag=rdiffbackuptag,
){

  include rsyncd

  @@rsyncd::export{ $rdiff_name:
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
  }

  @@file{ $remote_path:
    ensure => directory,
    path   => $remote_path,
    owner  => $uid,
    group  => $gid,
    tag    => $rdiffbackuptag,
  }

  cron{ $rdiff_name:
    command => "rdiff-backup ${path} ${gid}@${rdiff_server}::${remote_path}",
    user    => $uid,
    hour    => 1,
  }
}
