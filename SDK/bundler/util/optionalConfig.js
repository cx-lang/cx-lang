'use strict'

const optionalFile = require( './optionalFile' )

function optionalConfig( filename ) {

  let meta = optionalFile( filename, {} )

  if ( typeof meta === 'string' ) {

    meta = JSON.parse( meta )

  }

  return meta

}

module.exports = optionalConfig
