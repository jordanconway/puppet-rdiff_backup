# Class: rdiff_backup ===========================
#
# rdiff_backup class sets up the rdiffbackup server by default.
# You should also configure the rdiff_backup::client class for a fully working
# system.
#
# Parameters ----------
#
# * `remote_path`
# Defaults to '/srv/rdiff' The path on the rdiff-backup server that will contain
# your backups.
#
# * `rdiffbackuptag`
# Defaults to '$::fqdn'. This is used to aid resource collection on the 
# rdiff-backup server. It you can manage different servers for different nodes 
# with different rdiffbackuptags.
#
# Examples --------
#
# @example class { 'rdiff_backup':
#             remote_path    => '/srv/backups',
#             rdiffbackuptag => 'server1backups'
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
  $remote_path = $rdiff_backup::params::remote_path,
){

  include rdiff_backup::params
  # Anchors
  anchor { 'rdiff_backup::begin': }
  anchor { 'rdiff_backup::end': }

  class { 'rdiff_backup::server::install':
    remote_path => $remote_path
  }

  class {'rdiff_backup::server::import':
    rdiffbackuptag => $rdiffbackuptag
  }

  Anchor['rdiff_backup::begin'] ->
  Class['rdiff_backup::server::install'] ->
  Class['rdiff_backup::server::import'] ->
  Anchor['rdiff_backup::end']

}
