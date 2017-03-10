import { join } from 'path'

const _require = require

export function require( id ) {

  return _require( join( __dirname, id ) )

}
