#new rdiff_export
define rdiff_backup::rdiff_export (
  $ensure = present,
  $path = undef,
  $rdiff_retention = '1D',
  $cron_hour = '1',
  $cron_minute = '0',
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
  validate_re($rdiff_user, '^([a-z_][a-z0-9_]{0,30})$')
  validate_absolute_path($remote_path)
  validate_string($rdiff_server)
  validate_string($rdiffbackuptag)
  include ::rdiff_backup::client

  if ($path) {
    $cleanpath = regsubst(regsubst($path, '\/', '_', 'G'),'_', '')
  }

  $backup_script = "/usr/local/bin/rdiff_${cleanpath}_run.sh"

  if ( $rdiff_server == $::fqdn){
    concat::fragment{ "backup_${cleanpath}":
      target  => $backup_script,
      #lint:ignore:80chars
      content => "rdiff-backup ${path} ${remote_path}/${::fqdn}/${cleanpath}\n\n",
      #lint:endignore
      order   => '10'
    }

    concat::fragment{ "retention_${cleanpath}":
      target  => $backup_script,
      #lint:ignore:80chars
      content => "rdiff-backup -v0 --force --remove-older-than ${rdiff_retention} ${remote_path}/${::fqdn}/${cleanpath}\n\n",
      #lint:endignore
      order   => '15'
    }
  }
  else {
    concat::fragment{ "backup_${cleanpath}":
      target  => $backup_script,
      #lint:ignore:80chars
      content => "rdiff-backup ${path} ${rdiff_user}@${rdiff_server}::${remote_path}/${::fqdn}/${cleanpath}\n\n",
      #lint:endignore
      order   => '10'
    }

    concat::fragment{ "retention_${cleanpath}":
      target  => $backup_script,
      #lint:ignore:80chars
      content => "rdiff-backup -v0 --force --remove-older-than ${rdiff_retention} ${rdiff_user}@${rdiff_server}::${remote_path}/${::fqdn}/${cleanpath}\n\n",
      #lint:endignore
      order   => '15'
    }
  }

  concat { $backup_script:
    owner => 'root',
    group => 'root',
    mode  => '0700',
    tag   => $rdiffbackuptag,
  }

  concat::fragment{ "backup_script_header_${cleanpath}":
    target  => $backup_script,
    content => "#!/bin/sh\n",
    order   => '01',
    tag     => $rdiffbackuptag,
  }

  cron{ "${::fqdn}_${cleanpath}":
    ensure  => $ensure,
    command => $backup_script,
    user    => root,
    hour    => $cron_hour,
    minute  => $cron_minute,
  }

}
