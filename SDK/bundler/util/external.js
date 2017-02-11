'use strict'

const meta = require( './optionalConfig' )( 'package.json' )
const __hasOwnProperty = Object.prototype.hasOwnProperty

const list = []
const map = {}

function add( externals ) {

  let index = list.length

  for ( const external in externals ) {

    if ( ! __hasOwnProperty.call( externals, external ) ) continue

    list[ index++ ] = external
    map[ external ] = true

  }

}

add( process.binding( 'natives' ) )

add( meta.dependencies || {} )
add( meta.devDependencies || {} )
add( meta.optionalDependencies || {} )

module.exports = { list, map }
