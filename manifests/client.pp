# Class: rdiff_backup
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
class rdiff_backup::client (
  $package = $rdiff_backup::params::package,
  $ensure = $rdiff_backup::params::ensure,
  $path = $rdiff_backup::params::path,
  $remote_path = $rdiff_backup::params::remote_path,
  $rdiff_server = $rdiff_backup::params::rdiff_server,
  $rdiffbackuptag = $rdiff_backup::params::rdiffbackuptag,
  $rdiff_user = $rdiff_backup::params::rdiff_user,
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
  if ($rdiffbackuptag){
    validate_string($rdiffbackuptag)
  }

  # Anchors
  anchor { 'rdiff_backup::client::begin': }
  anchor { 'rdiff_backup::client::end': }
  
  class { 'rdiff_backup::client::user':
    rdiff_user => $rdiff_user
  }
  
  class {'rdiff_backup::client::install':
    package        => $package,
    path           => $path,
    rdiffbackuptag => $rdiffbackuptag,
  }

  class {'rdiff_backup::client::config::export':
    ensure         => $ensure,
    path           => $path,
    rdiff_server   => $rdiff_server,
    rdiff_user     => $rdiff_user,
    remote_path    => $remote_path,
    rdiffbackuptag => $rdiffbackuptag,
  }

  Anchor['rdiff_backup::client::begin'] ->
    Class['rdiff_backup::client::user'] ->
    Class['rdiff_backup::client::install'] ->
    Class['rdiff_backup::client::config::export'] ->
  Anchor['rdiff_backup::client::end']

}
