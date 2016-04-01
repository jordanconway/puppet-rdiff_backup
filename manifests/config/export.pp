# rdiff_backup::config::export class
class rdiff_backup::config::export (
  $rsyncd_export_ensure,
  $rsyncd_export_chroot,
  $rsyncd_export_readonly,
  $rsyncd_export_mungesymlinks,
  $rsyncd_export_path,
  $rsyncd_export_uid,
  $rsyncd_export_gid,
  $rsyncd_export_users,
  $rsyncd_export_secrets,
  $rsyncd_export_allow,
  $rsyncd_export_deny,
  $rsyncd_export_prexferexec,
  $rsyncd_export_postxferexec,
){
  validate_string($rsyncd_export_ensure)
  validate_bool($rsyncd_export_chroot)
  validate_bool($rsyncd_export_readonly)
  validate_bool($rsyncd_export_mungesymlinks)
  if ($rsyncd_export_path){
    validate_absolute_path($rsyncd_export_path)
  }
  if ($rsyncd_export_uid){
    validate_string($rsyncd_export_uid)
  }
  if ($rsyncd_export_gid){
    validate_string($rsyncd_export_gid)
  }
  if ($rsyncd_export_users){
    validate_string($rsyncd_export_users)
  }
  if ($rsyncd_export_secrets){
    validate_string($rsyncd_export_secrets)
  }
  if ($rsyncd_export_allow){
    validate_ip_address($rsyncd_export_allow)
  }
  if ($rsyncd_export_deny){
    validate_ip_address($rsyncd_export_deny)
  }
  if ($rsyncd_export_prexferexec){
    validate_absolute_path($rsyncd_export_prexferexec)
  }
  if ($rsyncd_export_postxferexec){
    validate_string($rsyncd_export_postxferexec)
  }


}
