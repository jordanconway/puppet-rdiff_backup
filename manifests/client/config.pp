# Class: rdiff_backup::config
# ===========================
#
# Full description of class rdiff_backup here.
#
# Parameters
# ----------
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
class rdiff_backup::client::config (
  $ensure,
  $path,
  $rdiff_server,
  $remote_path,
  $backup_script,
  $rdiffbackuptag,
) inherits rdiff_backup::params {
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
  if ($rdiffbackuptag){
    validate_string($rdiffbackuptag)
  }

  # Anchors
  anchor { 'rdiff_backup::client::config::begin': }
  anchor { 'rdiff_backup::client::config::end': }

  class {'rdiff_backup::client::config::export':
    ensure         => $ensure,
    path           => $path,
    rdiff_server   => $rdiff_server,
    remote_path    => $remote_path,
    rdiffbackuptag => $rdiffbackuptag
  }

  class {'rdiff_backup::client::config::script':
    backup_script  => $backup_script,
    rdiffbackuptag => $rdiffbackuptag
  }

  Anchor['rdiff_backup::client::config::begin'] ->
    Class['rdiff_backup::client::config::export'] ->
    Class['rdiff_backup::client::config::script'] ->
  Anchor['rdiff_backup::client::config::end']

}
