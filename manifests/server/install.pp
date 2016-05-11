# rdiff_backup::install class
class rdiff_backup::server::install (
  $remote_path,
){

  file { $remote_path:
    ensure => directory,
  }

}
