# Class: rdiff_backup::client::config
# ===================================
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
  $backup_script,
  $rdiffbackuptag,
) inherits rdiff_backup::params {
  validate_string($rdiffbackuptag)
  validate_absolute_path($backup_script)

  # Anchors
  anchor { 'rdiff_backup::client::config::begin': }
  anchor { 'rdiff_backup::client::config::end': }

  class {'rdiff_backup::client::config::script':
    backup_script  => $backup_script,
    rdiffbackuptag => $rdiffbackuptag
  }

  Anchor['rdiff_backup::client::config::begin'] ->
    Class['rdiff_backup::client::config::script'] ->
  Anchor['rdiff_backup::client::config::end']

}
