'use strict'

/*eslint key-spacing: 0*/

if ( require.main === module ) process.exit( 0 )

/*--------- Dependencies ---------*/

const globby = require( 'globby' )
const json5 = require( 'json5' )
const minimist = require( 'minimist' )
const mkdirp = require( 'mkdirp' )
const fs = require( 'fs' )
const path = require( 'path' )

/*--------- Command line arguments ---------*/

let cliArgs = false

if ( process.argv.length > 2 ) {

  cliArgs = minimist( process.argv.slice( 2 ) )

  cliArgs._ = cliArgs._.length ? cliArgs._ : false

}

/*--------- Global options ---------*/

Object.assign( global, {

  WORKING_DIR: path.join( __dirname, '..' ),
  OPTIONS:     cliArgs ? cliArgs : {},
  PATHS:       cliArgs ? cliArgs._ : false,
  SEPARATOR:   path.sep

} )

/*--------- Global utilities ---------*/

Object.assign( global, {

  // aliases to useful module methods

  join:      path.join,
  exists:    fs.existsSync,
  exit:      process.exit,
  mkdir:     mkdirp.sync,
  writeFile: fs.writeFileSync,

  // log a error on the console and exit Node.js

  die( err, ...args ) {

    console.error( err.stack || err.message || err, ...args )
    process.exit( 1 )

  },

  // a simple path parser

  pathinfo( filename ) {

    const parts = filename.split( SEPARATOR )

    return {

      path: filename,
      name: parts.pop(),
      dir: parts.join( SEPARATOR )

    }

  },

  // returns a forward-slashed path

  forward( filename ) {

    return filename.replace( SEPARATOR, '/' )

  },

  // a modified version of `fs.lstatSync`

  lstat( filename ) {

    const stat = fs.lstatSync( filename )
    const parts = filename.split( SEPARATOR )

    stat.path = filename
    stat.name = parts.pop()
    stat.dir = parts.join( SEPARATOR )

    return stat

  },

  // reads a `utf8` file

  readFile( filename ) {

    return fs.readFileSync( filename, 'utf8' )

  },

  // reads a `utf8` json5 file and returns a javascript object

  readJSON( filename ) {

    return json5.parse( fs.readFileSync( filename, 'utf8' ) )

  },

  // write a javascript object to a `utf8` json file

  writeJSON( filename, data, ws = '  ' ) {

    fs.writeFileSync( filename, JSON.stringify( data, null, ws ) )

  },

  // find file-system entries that exist and match given patterns,
  // calling callback on each entry

  glob( patterns, callback, opts = {} ) {

    opts.cwd = opts.cwd || WORKING_DIR

    globby
      .sync( patterns, opts )
      .forEach( function iterator( file ) {

        callback( path.join( opts.cwd, file ), file )

      } )

  }

} )
