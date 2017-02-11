'use strict'

const { existsSync } = require( 'fs' )
const die = require( './die' )

const TARGET_PREFIX = 'target-'
let name = false

for ( const arg of process.argv ) {

  if ( arg.includes( TARGET_PREFIX ) ) {

    name = arg.replace( TARGET_PREFIX, '' )
    break

  }

}

if ( name === false ) {

  die(

    'You must specify a target with a cli argument prefixed with: '
    + `'${ TARGET_PREFIX }'`

  )

}

if ( ! existsSync( 'Source/' + name ) ) {

  die( `The specified target 'Source/${ name }' does not exist.` )

}

module.exports = name
