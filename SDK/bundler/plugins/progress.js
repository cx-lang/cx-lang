'use strict'

const { sep } = require( 'path' )
const { green, red, yellow } = require( 'chalk' )
const { createFilter } = require( 'rollup-pluginutils' )

function normalizePath( id ) {

  return id
    .replace( process.cwd() + sep, '' )
    .split( sep )
    .join( '/' )

}

function print ( output ) {

  if ( print.clearLine ) {

    const stdout = process.stdout
    const columns = stdout.columns

    stdout.clearLine()
    stdout.cursorTo( 0 )

    if ( ! ( output.length < columns ) ) {

      output = output.substring( 0, columns - 1 )

    }

    stdout.write( output )
    return void 0

  }

  console.log( output )

}

module.exports = function progress( options = {} ) {

  const filter = createFilter( options.include, options.exclude )
  let filesLoaded = 0

  print.clearLine = process.stdin.isTTY ? true : false

  if ( typeof options.clearLine === 'boolean' ) {

    print.clearLine = options.clearLine === true && print.clearLine

  }

  return {

    name: 'progress',

    get loaded() {

      return filesLoaded

    },

    transform( code, id ) {

      const filename = normalizePath( id )

      if ( ! filter( filename ) ) return void 0

      ++filesLoaded

      if ( filename.indexOf( ':' ) !== -1 ) return void 0

      print( `+ (${ red( filesLoaded ) }) ${ yellow( filename ) }` )

    },

    ongenerate() {

      print( `Bundled ${ green( filesLoaded ) } files.` )

    }

  }

}
