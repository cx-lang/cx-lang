#!/usr/bin/env node

'use strict'

/*--------- 1) Dependencies ---------*/

require( './globalHelpers' )

const rimraf = require( 'rimraf' ).sync

/*--------- 2) Options ---------*/

let patterns = [ 'lib', '.eslintcache' ]

if ( PATHS ) {

  patterns = PATHS
  WORKING_DIR = process.cwd()

}

/*--------- 3) Cleaner ---------*/

glob( patterns, ( filename, id ) => {

  try {

    rimraf( filename )
    console.log( 'Removed ' + id )

  } catch ( error ) {

    console.error( error )

  }

} )
