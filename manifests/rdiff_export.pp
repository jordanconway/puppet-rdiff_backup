#new rdiff_export
define rdiff_backup::rdiff_export (
  $ensure = present,
  $path = undef,
  $rdiff_retention = '1D',
  $cron_hour = '1',
  $cron_minute = '0',
  $cron_jitter = 1,
  $include = undef,
  $exclude = undef,
  $rdiff_user = $::rdiff_backup::client::rdiff_user,
  $remote_path = $::rdiff_backup::client::remote_path,
  $rdiff_server = $::rdiff_backup::client::rdiff_server,
  $rdiffbackuptag = $::rdiff_backup::client::rdiffbackuptag,
){
  validate_string($ensure)
  validate_absolute_path($path)
  validate_re($rdiff_retention, '^(?:\d+[YMWDhms])+$')
  validate_re($cron_hour, '^[0-1]?[0-9]$|^[0-2]?[0-3]$')
  validate_re($cron_minute, '^[0-5]?[0-9]$')
  validate_integer($cron_jitter, undef, 1)
  validate_re($rdiff_user, '^([a-z_][a-z0-9_]{0,30})$')
  validate_absolute_path($remote_path)
  validate_string($rdiff_server)
  validate_string($rdiffbackuptag)
  include ::rdiff_backup::client

  if ($path) {
    $cleanpath = regsubst(regsubst($path, '\/', '_', 'G'),'_', '')
  }

  if is_array($include) {
    $_include = join(prefix($include, '--include '), ' ')
  } elsif $include != undef and is_string($include){
    $_include = "--include ${include}"
  } else {
    $_include = ''
  }

  if is_array($exclude) {
    $_exclude = join(prefix($exclude, '--exclude '), ' ')
  } elsif $exclude != undef and is_string($exclude){
    $_exclude = "--exclude ${exclude}"
  } else {
    $_exclude = ''
  }

  $backup_script = "/usr/local/bin/rdiff_${cleanpath}_run.sh"

  if ( $rdiff_server == $::fqdn){
    file { $backup_script:
      ensure  => $ensure,
      owner   => 'root',
      mode    => '0700',
      content => template('rabbitmq/backup_script_server.erb'),
      tag     => $rdiffbackuptag,
    }
  }
  else {
    file { $backup_script:
      ensure  => $ensure,
      owner   => 'root',
      mode    => '0700',
      content => template('rabbitmq/backup_script_server.erb'),
      tag     => $rdiffbackuptag,
    }
  }

  cron{ "${::fqdn}_${cleanpath}":
    ensure  => $ensure,
    command => $backup_script,
    user    => root,
    hour    => $cron_hour,
    minute  => $cron_minute,
  }

}
