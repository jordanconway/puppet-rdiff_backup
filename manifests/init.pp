# Class: rdiff_backup ===========================
#
# rdiff_backup class sets up the rdiffbackup server by default.  You should
# also configure the rdiff_backup::client class for a fully working system.
#
# Parameters ----------
#
# [*rdiff_user*]
#   The user that will be created on the backup server and run the server side
#   of rdiff-backup.
#
#   Type: String
#   Default: see $rdiff_backup::params::rdiff_user
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
# Examples --------
#
# @example class { 'rdiff_backup':
#            remote_path    => '/srv/backups',
#            rdiff_user     => 'backupmgr',
#            rdiffbackuptag => 'server1backups'
#          }
#
# Authors -------
#
# Jordan Conway  <jconway@linuxfoundation.org>
#
# Copyright ---------
#
# Copyright 2016 Jordan Conway.
#
class rdiff_backup (
  $rdiffbackuptag = $rdiff_backup::params::rdiffbackuptag,
  $rdiff_user     = $rdiff_backup::params::rdiff_user,
  $rdiff_group    = $rdiff_backup::params::rdiff_group,
  $remote_path    = $rdiff_backup::params::remote_path,
  $package        = $rdiff_backup::params::package,
) inherits rdiff_backup::params {
  validate_string($rdiffbackuptag)
  validate_string($rdiff_user)
  validate_string($package)
  validate_absolute_path($remote_path)

  include rdiff_backup::params
  # Anchors
  anchor { 'rdiff_backup::begin': }
  anchor { 'rdiff_backup::end': }

  class { 'rdiff_backup::server::user':
    rdiff_user => $rdiff_user
    rdiff_user => $rdiff_group
  }

  class { 'rdiff_backup::server::install':
    remote_path => $remote_path,
    package     => $package,
    rdiff_user  => $rdiff_user,
    rdiff_group  => $rdiff_group,
  }

  class {'rdiff_backup::server::import':
    rdiffbackuptag => $rdiffbackuptag
  }

  Anchor['rdiff_backup::begin'] ->
    Class['rdiff_backup::server::user'] ->
    Class['rdiff_backup::server::install'] ->
    Class['rdiff_backup::server::import'] ->
  Anchor['rdiff_backup::end']

}
