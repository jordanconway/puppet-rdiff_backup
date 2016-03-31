# rdiff_backup::server::serviceclass
class rdiff_backup::server::service (
  $rsyncd_xinetd_service,
){
  validate_string($rsyncd_xinetd_service)
  # Setup xinetd service
  service { $rsyncd_xinetd_service:
    ensure     => running,
    enable     => true,
    hasrestart => true,
  }

}
