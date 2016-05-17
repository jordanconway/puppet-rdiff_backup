# Class: rdiff_backup
# ===========================
#
# Full description of class rdiff_backup here.
#
# Parameters
# ----------
#
# * `package`
# Defaults to 'rdiff-backup'. Module is CentOS/RHEL specific right now, if you
# use a custom package for rdiff-backup, specify it here.
#
# * `rdiff_server`
# Defaults to undef. Set this to the FQDN of the node you will use as your
# rdiff-backup server.
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
# * `backup_script`
# Defaults to '/usr/local/bin/rdiff_backup.sh'
# No need to change unless you prefer scripts to be run from elsewhere or named
# differently.
#
# Examples
# --------
#
# @example
#    class { 'rdiff_backup':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
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
  $package = $rdiff_backup::params::package,
  $rdiff_server = $rdiff_backup::params::rdiff_server,
  $backup_script = $rdiff_backup::params::backup_script,
  $rdiffbackuptag = $::rdiff_backup::rdiffbackuptag,
  $remote_path = $::rdiff_backup::remote_path,
  $rdiff_user = $::rdiff_backup::rdiff_user,
) {
  validate_string($package)
  validate_string($rdiff_server)
  validate_string($remote_path)
  validate_string($backup_script)
  validate_string($rdiffbackuptag)
  
  include ::rdiff_backup

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
