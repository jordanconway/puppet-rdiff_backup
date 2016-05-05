# Class: rdiff_backup ===========================
#
# Full description of class rdiff_backup here.
#
# Parameters ----------
#
# Document parameters here.
#
# * `sample parameter` Explanation of what this parameter affects and what it
# defaults to.  e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable` Explanation of how this variable affects the function of
# this class and if it has a default. e.g. "The parameter enc_ntp_servers must
# be set by the External Node Classifier as a comma separated list of
# hostnames." (Note, global variables should be avoided in favor of class
# parameters as of Puppet 2.6.)
#
# Examples --------
#
# @example class { 'rdiff_backup': servers => [ 'pool.ntp.org',
# 'ntp.local.company.com' ], }
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
  $rsyncd_xinetd_service = $rdiff_backup::params::rsyncd_xinetd_service,
  $rsyncd_xinetd_package = $rdiff_backup::params::rsyncd_xinetd_package,
  $rdiffbackuptag
){
  validate_string($rsyncd_xinetd_service)
  validate_string($rsyncd_xinetd_package)
  if ($rdiffbackuptag){
    validate_string($rdiffbackuptag)
  }

  include rdiff_backup::params

  # Anchors
  anchor { 'rdiff_backup::begin': }
  anchor { 'rdiff_backup::end': }

  class { 'rdiff_backup::server::install':
    rsyncd_xinetd_package => $rsyncd_xinetd_package
  }
  class { 'rdiff_backup::server::service':
    rsyncd_xinetd_service => $rsyncd_xinetd_service
  }

  class {'rdiff_backup::server::import':
    rdiffbackuptag => $rdiffbackuptag
  }

  Anchor['rdiff_backup::begin'] ->
  Class['rdiff_backup::server::install'] ->
  Class['rdiff_backup::server::service'] ->
  Class['rdiff_backup::server::import'] ->
  Anchor['rdiff_backup::end']

}
