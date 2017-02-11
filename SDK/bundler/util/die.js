'use strict'

module.exports = function die( err ) {

  if ( err )

    console.error( err.stack || err.message || err )

  process.exit( 1 )

}
