# rdiff_backup::params class
class rdiff_backup::params {
  $package = 'rdiff-backup'
  $remote_path = '/srv/rdiff'
  $rdiff_server = "backup.${::domain}"
  $rdiffbackuptag = 'rdiffbackuptag'
  $rdiff_user = 'rdiffbackup'
  $backup_script = '/usr/local/bin/rdiff_backup.sh'
}
