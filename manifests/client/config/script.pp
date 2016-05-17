# Class: rdiff_backup::client::config::script
# ===========================================
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
class rdiff_backup::client::config::script(
  $rdiffbackuptag,
  $backup_script,
){
  validate_string($rdiffbackuptag)
  validate_absolute_path($backup_script)

  concat { $backup_script:
    owner => 'root',
    group => 'root',
    mode  => '0700',
    tag   => $rdiffbackuptag,
  }

  concat::fragment{ 'backup_script_header':
    target  => $backup_script,
    content => "#!/bin/sh\n",
    order   => '01',
    tag     => $rdiffbackuptag,
  }

}
