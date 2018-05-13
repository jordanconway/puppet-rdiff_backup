# rdiff_backup::params class
class rdiff_backup::params {
  $package = 'rdiff-backup'
  $remote_path = '/srv/rdiff'
  $rdiff_server = "backup.${::domain}"
  $rdiffbackuptag = 'rdiffbackuptag'
  $rdiff_user = 'rdiffbackup'
  $rdiff_group = 'root'
}
