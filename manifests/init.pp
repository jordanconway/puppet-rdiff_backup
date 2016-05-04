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
class rdiff_backup (
  $package = $rdiff_backup::params::package,
  $rsyncd_rsync_package = $rdiff_backup::params::rsyncd_rsync_package,
  $rsyncd_xinetd_package = $ridff_backup::params::rsyncd_xinetd_package,
  $rsyncd_xinetd_service = $ridff_backup::params::rsyncd_xinetd_service,
  $ensure = $rdiff_backup::params::ensure,
  $chroot = $rdiff_backup::params::chroot,
  $readonly = $rdiff_backup::params::readonly,
  #lintignore:80chars
  $mungesymlinks = $rdiff_backup::params::mungesymlinks,
  #lint:endignore
  $path = $rdiff_backup::params::path,
  $uid = $rdiff_backup::params::uid,
  $gid = $rdiff_backup::params::gid,
  $users = $rdiff_backup::params::users,
  $secrets = $rdiff_backup::params::secrets,
  $allow = $rdiff_backup::params::allow,
  $deny = $rdiff_backup::params::deny,
  $prexferexec = $rdiff_backup::params::prexferexec,
  $postxferexec = $rdiff_backup::params::postxferexec,
  $remote_path = $rdiff_backup::params::remote_path,
  $rdiff_server = $rdiff_backup::params::rdiff_server,
  $rdiffbackuptag = $rdiff_backup::params::rdiffbackuptag
) inherits rdiff_backup::params {
  validate_string($package)
  validate_string($rsyncd_rsync_package)
  validate_string($rsyncd_xinetd_package)
  if ($ensure){
    validate_string($ensure)
  }
  if ($chroot){
    validate_bool($chroot)
  }
  if ($readonly){
    validate_bool($readonly)
  }
  if ($mungesymlinks){
    validate_bool($mungesymlinks)
  }
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
  if ($rdiffbackuptag){
    validate_string($rdiffbackuptag)
  }

  # Anchors
  anchor { 'rdiff_backup::begin': }
  anchor { 'rdiff_backup::end': }

  class {'rdiff_backup::install':
    package => $package,
    rsyncd_rsync_package => $rsyncd_rsync_package,
  }

  class {'rdiff_backup::config::export':
    ensure => $ensure,
    chroot => $chroot,
    readonly => $readonly,
    mungesymlinks => $mungesymlinks,
    path => $path,
    uid => $uid,
    gid => $gid,
    users => $users,
    secrets => $secrets,
    allow => $allow,
    deny => $deny,
    prexferexec => $prexferexec,
    postxferexec => $postxferexec,
    rdiff_server => $rdiff_server,
    remote_path => $remote_path,
    rdiffbackuptag => $rdiffbackuptag,
  }

  Anchor['rdiff_backup::begin'] ->
    Class['rdiff_backup::install'] ->
    Class['rdiff_backup::config::export'] ->
  Anchor['rdiff_backup::end']

}
