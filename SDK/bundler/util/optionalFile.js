'use strict'

const { existsSync, readFileSync } = require( 'fs' )

function optionalFile( filename, alternativeContent ) {

  if ( existsSync( filename ) ) {

    return readFileSync( filename, 'utf8' )

  }

  return alternativeContent || ''

}

module.exports = optionalFile
