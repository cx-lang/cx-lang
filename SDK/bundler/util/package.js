'use strict'

const optionalFile = require( './optionalFile' )

let meta = optionalFile( 'package.json', {} )

if ( typeof meta === 'string' ) {

  meta = JSON.parse( meta )

}

module.exports = meta
