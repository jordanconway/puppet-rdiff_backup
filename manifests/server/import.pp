# rdiff_backup::server::import class
class rdiff_backup::server::import(
  $rdiffbackuptag,
){
  if ($rdiffbackuptag){
    validate_string($rdiffbackuptag)
  }

  File <<| tag == $rdiffbackuptag |>> { }
  Sshkeys::Set_authorized_key <<| tag == $rdiffbackuptag |>> { }
}
