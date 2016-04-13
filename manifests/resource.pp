define rdiff_backup::rsyncd_export (
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

}
