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
  $rdiffbackuptag=rdiffbackuptag,
){

  include rsyncd

  @@rsyncd::export{ $title:
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
  }

  cron{ $title:
    command => "rdiff-backup ${path} ${gid}@${rdiff_server}::${remote_path}",
    user    => $uid,
    hour    => 1,
  }
}
