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
  $remote_path,
  $rdiff_server,
  $rdiffbackuptag
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
  if ($rdiff_server){
    validate_string($rdiff_server)
  }
  if ($remote_path){
    validate_string($remote_path)
    $_remote_path = $remote_path
  }
  else {
    $_remote_path = "/rdiff_backups/${path}"
  }
  if ($rdiffbackuptag){
    validate_string($rdiffbackuptag)
  }

  # We need some variables out of rdiff_backup::params
  include rdiff_backup::params


  create_resources('rdiff_export', {
    title          => "${::fqdn}_${path}",
    ensure         => $ensure,
    chroot         => $chroot,
    readonly       => $readonly,
    mungesymlinks  => $mungesymlinks,
    path           => $path,
    uid            => $uid,
    gid            => $gid,
    users          => $users,
    secrets        => $secrets,
    allow          => $allow,
    deny           => $deny,
    prexferexec    => $prexferexec,
    postxferexec   => $postxferexec,
    rdiff_server   => $rdiff_server,
    remote_path    => $_remote_path,
    rdiffbackuptag => $rdiffbackuptag,
  })
}
