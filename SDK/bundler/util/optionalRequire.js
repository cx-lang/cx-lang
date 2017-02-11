'use strict'

const { existsSync } = require( 'fs' )

function optionalRequire( filename ) {

  if ( ! existsSync( filename ) ) return {}

  return require( filename )

}

module.exports = optionalRequire
