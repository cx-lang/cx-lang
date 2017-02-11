'use strict'

const globby = require( 'globby' ).sync
const minimist = require( 'minimist' )
const Mocha = require( 'mocha' )
const { join } = require( 'path' )

const cwd = join( __dirname, '..', '..' )

global.cxlang = require( join( root, 'index.js' ) )
global.expect = require( './Expecter' ).expect

global.mocha = new Mocha( Object.assign( {

  ui: 'bdd',
  reporter: 'spec',
  timeout: 30000

}, minimist( process.argv.slice( 2 ) ) ) )

globby(
  [ '**/*.{spec,test}.js' ],
  { cwd: join( cwd, 'Source' ) }
)
.forEach( file => {

  const filename = join( cwd, 'Source', file )

  if ( file.endsWith( '.spec.js' ) )

    require( filename )

  else

    mocha.addFile( filename )

} )

mocha.run( process.exit )
