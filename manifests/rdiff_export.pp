#new rdiff_export
define rdiff_backup::rdiff_export (
  $ensure = present,
  $path = undef,
  $rdiff_retention = undef,
  $rdiff_user = $::rdiff_backup::client::rdiff_user,
  $remote_path = $::rdiff_backup::client::remote_path,
  $rdiff_server = $::rdiff_backup::client::rdiff_server,
  $rdiffbackuptag = $::rdiff_backup::client::rdiffbackuptag,
  $backup_script = $::rdiff_backup::client::backup_script,
){

  include ::rdiff_backup::client

  if ($path) {
    $cleanpath = regsubst(regsubst($path, '\/', '_', 'G'),'_', '')
  }

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

  cron{ "${::fqdn}${cleanpath}":
    command => $backup_script,
    user    => root,
    hour    => 1,
  }

}
