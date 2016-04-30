# rdiff_backup::server::import class
class rdiff_backup::server::import(
  $rdiffbackuptag,
){
  validate_string($rdiffbackuptag)

  RRsyncd::Export <<| tag == $rdiffbackuptag |>> { }
}
