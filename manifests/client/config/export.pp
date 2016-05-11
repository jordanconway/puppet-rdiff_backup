# rdiff_backup::config::export class
class rdiff_backup::client::config::export (
  $ensure,
  $path,
  $remote_path,
  $rdiff_server,
  $rdiffbackuptag
){
  if ($ensure){
    validate_string($ensure)
  }
  if ($path){
    validate_absolute_path($path)
  }
  if ($rdiff_server){
    validate_string($rdiff_server)
  }
  if ($remote_path){
    validate_string($remote_path)
    $_remote_path = $remote_path
  }
  else {
    $_remote_path = '/srv/rdiff'
  }
  if ($rdiffbackuptag){
    validate_string($rdiffbackuptag)
  }

  # We need some variables out of rdiff_backup::params
  include rdiff_backup::params

  if ( $::fqdn and $path ) {
    create_resources('rdiff_backup::rdiff_export', {
      "${::fqdn}_${path}" => {
        ensure         => $ensure,
        path           => $path,
        rdiff_server   => $rdiff_server,
        remote_path    => $_remote_path,
        rdiffbackuptag => $rdiffbackuptag,
    }})
  }
}
