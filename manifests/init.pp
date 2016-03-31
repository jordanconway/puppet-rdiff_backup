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
  $rsyncd_export_ensure = $rdiff_backup::params::rsyncd_export_ensure,
  $rsyncd_export_chroot = $rdiff_backup::params::rsyncd_export_chroot,
  $rsyncd_export_readonly = $rdiff_backup::params::rsyncd_export_readonly,
  #lintignore:80chars
  $rsyncd_export_mungesymlinks = $rdiff_backup::params::rsyncd_export_mungesymlinks,
  #lint:endignore
  $rsyncd_export_path = $rdiff_backup::params::rsyncd_export_path,
  $rsyncd_export_uid = $rdiff_backup::params::rsyncd_export_uid,
  $rsyncd_export_gid = $rdiff_backup::params::rsyncd_export_gid,
  $rsyncd_export_users = $rdiff_backup::params::rsyncd_export_users,
  $rsyncd_export_secrets = $rdiff_backup::params::rsyncd_export_secrets,
  $rsyncd_export_allow = $rdiff_backup::params::rsyncd_export_allow,
  $rsyncd_export_deny = $rdiff_backup::params::rsyncd_export_deny,
  $rsyncd_export_prexferexec = $rdiff_backup::params::rsyncd_export_prexferexec,
  $rsyncd_export_postxferexec = $rdiff_backup::params::rsyncd_export_postxferexec,
) inherits rdiff_backup::params {
  validate_string($package)
  validate_string($rsyncd_rsync_package)
  validate_string($rsyncd_xinetd_package)
  validate_string($rsyncd_export_ensure)
  validate_bool($rsyncd_export_chroot)
  validate_bool($rsyncd_export_readonly)
  validate_bool($rsyncd_export_mungesymlinks)
  if ($rsyncd_export_path){
    validate_absolute_path($rsyncd_export_path)
  }
  if ($rsyncd_export_uid){
    validate_string($rsyncd_export_uid)
  }
  if ($rsyncd_export_gid){
    validate_string($rsyncd_export_gid)
  }
  if ($rsyncd_export_users){
    validate_string($rsyncd_export_users)
  }
  if ($rsyncd_export_secrets){
    validate_string($rsyncd_export_secrets)
  }
  if ($rsyncd_export_allow){
    validate_ip_address($rsyncd_export_allow)
  }
  if ($rsyncd_export_deny){
    validate_ip_address($rsyncd_export_deny)
  }
  if ($rsyncd_export_prexferexec){
    validate_absolute_path($rsyncd_export_prexferexec)
  }
  if ($rsyncd_export_postxferexec){
    validate_string($rsyncd_export_postxferexec)
  }

  # Anchors
  anchor { 'rdiff_backup::begin': }
  anchor { 'rdiff_backup::end': }

  class {'rdiff_backup::install':
    package => $package,
  }

  class {'rdiff_backup::cron':
  }

  Anchor['rdiff_backup::begin'] ->
    Class['rdiff_backup::install'] ->
    Class['rdiff_backup::cron'] ->
  Anchor['rdiff_backup::end']

}
