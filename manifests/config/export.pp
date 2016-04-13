# rdiff_backup::config::export class
class rdiff_backup::config::export (
  $ensure,
  $chroot,
  $readonly,
  $mungesymlinks,
  $path,
  $uid,
  $gid,
  $users,
  $secrets,
  $allow,
  $deny,
  $prexferexec,
  $postxferexec,
){
  validate_string($ensure)
  validate_bool($chroot)
  validate_bool($readonly)
  validate_bool($mungesymlinks)
  if ($path){
    validate_absolute_path($path)
  }
  if ($uid){
    validate_string($uid)
  }
  if ($gid){
    validate_string($gid)
  }
  if ($users){
    validate_string($users)
  }
  if ($secrets){
    validate_string($secrets)
  }
  if ($allow){
    validate_ip_address($allow)
  }
  if ($deny){
    validate_ip_address($deny)
  }
  if ($prexferexec){
    validate_absolute_path($prexferexec)
  }
  if ($postxferexec){
    validate_string($postxferexec)
  }

  create_resource('@@rsyncd::export', "${::fqdn}_${path}", {
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
  })

}
