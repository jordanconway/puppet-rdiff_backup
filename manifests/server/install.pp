# rdiff_backup::install class
class rdiff_backup::server::install (
  $rsyncd_xinetd_package,
){

  # Setup rsycnd server
  include rsyncd

  validate_string($rsyncd_xinetd_package)

  ensure_packages($rsyncd_xinetd_package,
    { ensure  => present, }
  )

  if ( $::osfamily == 'RedHat' ){
    selboolean { 'rsync_full_access':
      persistent => true,
      value      => on,
    }
  }

}
