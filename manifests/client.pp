# Class: rdiff_backup::client
# ===========================
#
# Class that configured rdiff-backup clients and exports their info to the
# rdiff-backup server configured with Class['rdiff_backup'].
#
# Parameters
# ----------
#
# [*package*]
#   Module is currently CentOS/RHEL specific right now, if you use a custom
#   package for rdiff-backup, specify it here.
#
#   Type: String
#   Default see $rdiff_backup::params::package
#
# [*rdiff_user*]
#   The user that will be created on the backup server and run the server side
#   of rdiff-backup.
#
#   Type: String
#   Default: see $rdiff_backup::params::rdiff_user
#
# [*rdiff_server*]
#   Set this to the FQDN of the node you will use as your rdiff-backup server.
#
#   Type: String
#   Default: see $rdiff_backup::params::rdiff_server
#
# [*remote_path*]
#   The path on the rdiff-backup server that will contain your backups.
#
#   Type: String(absolute_path)
#   Default: see rdiff_backup::params::remote_path
#
# [*rdiffbackuptag*]
#   This is used to aid resource collection on the rdiff-backup server. You can
#   manage different servers for different nodes with different rdiffbackuptags.
#
#   Type: String
#   Default: see rdiff_backup::params::rdiffbackuptag
#
# [*backup_script*]
#   Full path of he script that is built to manage rdiff-backups and retentions.
#
#   Type: String(absolute_path)
#   Default: see rdiff_backup::params::backup_script
#
# Examples
# --------
#
# @example
#    class { 'rdiff_backup::client':
#      rdiff_user     => 'backupman',
#      rdiffbackuptag => 'rdiffbackup',
#      rdiff_server   => 'backups.mydomain.org',
#      remote_path    => '/srv/rdiffbackups',
#      rdiff_server   => 'puppet.jordanlab.local',
#      backup_script  => '/usr/local/bin/runbackups.sh',
#    }
#
# Authors
# -------
#
# Jordan Conway  <jconway@linuxfoundation.org>
#
# Copyright
# ---------
#
# Copyright 2016 Jordan Conway.
#
class rdiff_backup::client (
  $package        = $rdiff_backup::params::package,
  $rdiff_server   = $rdiff_backup::params::rdiff_server,
  $backup_script  = $rdiff_backup::params::backup_script,
  $rdiffbackuptag = $rdiff_backup::params::rdiffbackuptag,
  $remote_path    = $rdiff_backup::params::remote_path,
  $rdiff_user     = $rdiff_backup::params::rdiff_user,
) inherits rdiff_backup::params {
  validate_string($package)
  validate_string($rdiff_server)
  validate_absolute_path($remote_path)
  validate_string($backup_script)
  validate_string($rdiffbackuptag)

  include rdiff_backup::params

  # Anchors
  anchor { 'rdiff_backup::client::begin': }
  anchor { 'rdiff_backup::client::end': }

  class {'rdiff_backup::client::install':
    package        => $package,
    rdiff_server   => $rdiff_server,
    rdiff_user     => $rdiff_user,
    remote_path    => $remote_path,
    rdiffbackuptag => $rdiffbackuptag,
  }

  class {'rdiff_backup::client::config':
    backup_script  => $backup_script,
    rdiffbackuptag => $rdiffbackuptag,
  }

  Anchor['rdiff_backup::client::begin'] ->
    Class['rdiff_backup::client::install'] ->
    Class['rdiff_backup::client::config'] ->
  Anchor['rdiff_backup::client::end']

}
