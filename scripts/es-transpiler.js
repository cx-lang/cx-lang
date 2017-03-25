#!/usr/bin/env node

'use strict'

/*--------- 1) Dependencies ---------*/

require( './globalHelpers' )

const { transform } = require( 'babel-core' )
const { EOL } = require( 'os' )

/*--------- 2) Options ---------*/

let patterns = [ '**/*.js' ]
let srcDir = join( __dirname, '..', 'src' )
let outDir = join( __dirname, '..', 'lib' )

const mtcache = join( outDir, '.mtimes-cache.json' )

if ( PATHS ) {

  patterns = PATHS

  srcDir = OPTIONS.srcDir || srcDir
  outDir = OPTIONS.outDir || outDir

}

WORKING_DIR = srcDir

if ( ! exists( mtcache ) ) {

  mkdir( outDir )
  writeFile( mtcache, '{}' )

}

const babelrc = readJSON( join( srcDir, '.babelrc' ) )
const mtimes = require( mtcache )

/*--------- 3) Utilities ---------*/

babelrc.shouldPrintComment = function shouldPrintComment( comment ) {

  return comment.startsWith( 'eslint' ) === false

}

/*--------- 4) Transpiler ---------*/

glob( patterns, ( source, id ) => {

  const target = join( outDir, id )
  const mapfile = target + '.map'

  const stat = lstat( source )
  const mtime = +stat.mtime
  const basename = stat.name
  const dirname = pathinfo( target ).dir

  if ( ! stat.isFile() ) return false

  if ( exists( target ) && mtimes[ id ] ) {

    if ( mtime === mtimes[ id ] ) return false

  }
  mtimes[ id ] = mtime
  mtimes.updated = true

  let input, output
  const relativeName = relative( dirname, source )

  try {

    babelrc.filename = source
    babelrc.filenameRelative = relativeName
    babelrc.sourceFileName = relativeName
    babelrc.sourceMapTarget = relativeName
    babelrc.sourceRoot = relative( dirname, srcDir )

    input = readFile( source )
    output = transform( input, babelrc )

    output.code += EOL + EOL + `//# sourceMappingURL=${ basename }.map` + EOL

    mkdir( dirname )

    writeFile( target, output.code )
    writeJSON( mapfile, output.map )

    console.log( 'Transpiled ' + id.replace( SEPARATOR, '/' ) )

  } catch ( error ) {

    console.error( error )

  }

} )

if ( mtimes.updated ) {

  delete mtimes.updated
  writeJSON( mtcache, mtimes )

}
