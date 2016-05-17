#new rdiff_export
define rdiff_backup::rdiff_export (
  $ensure = present,
  $path = undef,
  $remote_path = $::remote_path,
  $rdiff_server = $::rdiff_server,
  $rdiffbackuptag = $::rdiffbackuptag,
  $rdiff_user = undef,
  $backup_script = $::backup_script,
  $rdiff_retention = undef,
){

  include ::rdiff_backup::client

  if ($path) {
    $cleanpath = regsubst(regsubst($path, '\/', '_', 'G'),'_', '')
  }

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

  cron{ "${::fqdn}${cleanpath}":
    command => $backup_script,
    user    => root,
    hour    => 1,
  }

}
