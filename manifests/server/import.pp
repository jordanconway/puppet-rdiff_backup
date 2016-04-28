# rdiff_backup::server::import class
class rdiff_backup::server::import(
  $rdiffbackuptag,
){
  validate_string($rdiffbackuptag)

  Rdiff_backup::Rdiff_export <<| tag == $rdiffbackuptag |>> { }
}
