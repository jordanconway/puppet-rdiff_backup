# rdiff_backup::server::import class
class rdiff_backup::server::import(
  $rdiffbackuptag,
){
  if ($rdiffbackuptag){
    validate_string($rdiffbackuptag)
  }

  User <<| tag == $rdiffbackuptag |>> { }
  File <<| tag == $rdiffbackuptag |>> { }
}
