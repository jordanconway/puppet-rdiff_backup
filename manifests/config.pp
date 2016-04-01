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
  $rsyncd_export_ensure,
  $rsyncd_export_chroot,
  $rsyncd_export_readonly,
  $rsyncd_export_mungesymlinks,
  $rsyncd_export_path,
  $rsyncd_export_uid,
  $rsyncd_export_gid,
  $rsyncd_export_users,
  $rsyncd_export_secrets,
  $rsyncd_export_allow,
  $rsyncd_export_deny,
  $rsyncd_export_prexferexec,
  $rsyncd_export_postxferexec,
  $rdiffbackuptag,
) inherits rdiff_backup::params {
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
  validate_string($rdiffbackuptag)

  # Anchors
  anchor { 'rdiff_backup::config::begin': }
  anchor { 'rdiff_backup::config::end': }

  class {'rdiff_backup::config::export':
    rsyncd_export_ensure        => $rsyncd_export_ensure,
    rsyncd_export_chroot        => $rsyncd_export_chroot,
    rsyncd_export_readonly      => $rsyncd_export_readonly,
    rsyncd_export_mungesymlinks => $rsyncd_export_mungesymlinks,
    rsyncd_export_path          => $rsyncd_export_path,
    rsyncd_export_uid           => $rsyncd_export_uid,
    rsyncd_export_gid           => $rsyncd_export_gid,
    rsyncd_export_users         => $rsyncd_export_users,
    rsyncd_export_secrets       => $rsyncd_export_secrets,
    rsyncd_export_allow         => $rsyncd_export_allow,
    rsyncd_export_deny          => $rsyncd_export_deny,
    rsyncd_export_prexferexec   => $rsyncd_export_prexferexec,
    rsyncd_export_postxferexec  => $rsyncd_export_postxferexec,
  }

  class {'rdiff_backup::config::import':
    rdiffbackuptag => $rdiffbackuptag
  }

  Anchor['rdiff_backup::config::begin'] ->
    Class['rdiff_backup::config::export'] ->
    Class['rdiff_backup::config::import'] ->
  Anchor['rdiff_backup::config::end']

}
