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
class rdiff_backup::config (
  $ensure,
  $chroot,
  $readonly,
  $mungesymlinks,
  $path,
  $uid,
  $gid,
  $users,
  $secrets,
  $allow,
  $deny,
  $prexferexec,
  $postxferexec,
  $rdiff_server,
  $remote_path,
  $rdiffbackuptag,
) inherits rdiff_backup::params {
  validate_string($ensure)
  validate_bool($chroot)
  validate_bool($readonly)
  validate_bool($mungesymlinks)
  if ($path){
    validate_absolute_path($path)
  }
  if ($uid){
    validate_string($uid)
  }
  if ($gid){
    validate_string($gid)
  }
  if ($users){
    validate_string($users)
  }
  if ($secrets){
    validate_string($secrets)
  }
  if ($allow){
    validate_ip_address($allow)
  }
  if ($deny){
    validate_ip_address($deny)
  }
  if ($prexferexec){
    validate_absolute_path($prexferexec)
  }
  if ($postxferexec){
    validate_string($postxferexec)
  }
  if ($rdiff_server){
    validate_string($rdiff_server)
  }
  if ($remote_path){
    validate_string($remote_path)
  }
  validate_string($rdiffbackuptag)

  # Anchors
  anchor { 'rdiff_backup::config::begin': }
  anchor { 'rdiff_backup::config::end': }

  class {'rdiff_backup::config::export':
    ensure         => $ensure,
    chroot         => $chroot,
    readonly       => $readonly,
    mungesymlinks  => $mungesymlinks,
    path           => $path,
    uid            => $uid,
    gid            => $gid,
    users          => $users,
    secrets        => $secrets,
    allow          => $allow,
    deny           => $deny,
    prexferexec    => $prexferexec,
    postxferexec   => $postxferexec,
    rdiff_server   => $rdiff_server,
    remote_path    => $remote_path,
    rdiffbackuptag => $rdiffbackuptag
  }

  class {'rdiff_backup::config::import':
    rdiffbackuptag => $rdiffbackuptag
  }

  Anchor['rdiff_backup::config::begin'] ->
    Class['rdiff_backup::config::export'] ->
    Class['rdiff_backup::config::import'] ->
  Anchor['rdiff_backup::config::end']

}
