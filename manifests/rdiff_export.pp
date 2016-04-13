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
  $rdiffbackuptag=undef,
){

  include rsyncd

  @@rsyncd::export{ $title:
    ensure        => $ensure,
    chroot        => $chroot,
    readonly      => $readonly,
    mungesymlinks => $mungesymlinks,
    path          => $path,
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
    command => '',
    user    => '',
    hour    => '',
  }
}
