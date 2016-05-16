# Class: rdiff_backup
# ===========================
#
# Full description of class rdiff_backup here.
#
# Parameters
# ----------
# * `ensure`
# Defaults to 'present' probablt not needed as a param... *FIXME*
#
# * `package`
# Defaults to 'rdiff-backup'. Module is CentOS/RHEL specific right now, if you
# use a custom package for rdiff-backup, specify it here.
#
# * `path`
# Defaults to undef, probably not actually needed at a param **FIXME**
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
#
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
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
  $ensure = $rdiff_backup::params::ensure,
  $path = $rdiff_backup::params::path,
  $remote_path = $rdiff_backup::params::remote_path,
  $rdiff_server = $rdiff_backup::params::rdiff_server,
  $rdiffbackuptag = $rdiff_backup::params::rdiffbackuptag,
  $rdiff_user = $rdiff_backup::params::rdiff_user,
  $backup_script = $rdiff_backup::params::backup_script,
) inherits rdiff_backup::params {
  validate_string($package)
  if ($ensure){
    validate_string($ensure)
  }
  if ($path){
    validate_absolute_path($path)
  }
  if ($rdiff_server){
    validate_string($rdiff_server)
  }
  if ($remote_path){
    validate_string($remote_path)
  }
  if ($backup_script){
    validate_string($backup_script)
  }
  if ($rdiffbackuptag){
    validate_string($rdiffbackuptag)
  }

  # Anchors
  anchor { 'rdiff_backup::client::begin': }
  anchor { 'rdiff_backup::client::end': }

  class {'rdiff_backup::client::install':
    package        => $package,
    path           => $path,
    rdiff_server   => $rdiff_server,
    rdiff_user     => $rdiff_user,
    remote_path    => $remote_path,
    backup_script  => $backup_script,
    rdiffbackuptag => $rdiffbackuptag,
  }

  class {'rdiff_backup::client::config::export':
    ensure         => $ensure,
    path           => $path,
    rdiff_server   => $rdiff_server,
    rdiff_user     => $rdiff_user,
    remote_path    => $remote_path,
    backup_script  => $backup_script,
    rdiffbackuptag => $rdiffbackuptag,
  }

  class {'rdiff_backup::client::config::script':
    ensure         => $ensure,
    path           => $path,
    rdiff_server   => $rdiff_server,
    rdiff_user     => $rdiff_user,
    remote_path    => $remote_path,
    backup_script  => $backup_script,
    rdiffbackuptag => $rdiffbackuptag,
  }

  Anchor['rdiff_backup::client::begin'] ->
    Class['rdiff_backup::client::install'] ->
    Class['rdiff_backup::client::config::export'] ->
    Class['rdiff_backup::client::config::script'] ->
  Anchor['rdiff_backup::client::end']

}
