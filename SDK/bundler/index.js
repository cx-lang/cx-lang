'use strict'

const { existsSync } = require( 'fs' )
const { join, sep } = require( 'path' )
const { rollup } = require( 'rollup' )
const babel = require( 'rollup-plugin-babel' )
const pegjs = require( './plugins/pegjs' )
const progress = require( './plugins/progress' )
const replace = require( 'rollup-plugin-replace' )
const resolver = require( './plugins/resolver' )

const die = require( './util/die' )
const optionalConfig = require( './util/optionalConfig' )
const optionalFile = require( './util/optionalFile' )
const external = require( './util/external' )

const TARGET = require( './util/target' )
const srcdir = join( process.cwd(), 'Source', TARGET )
const config = optionalConfig( srcdir + sep + '.projectrc' )
const meta = optionalConfig( 'package.json' )

let banner = config.banner || optionalFile( 'Source/banner.js' )
const sourceMap = config.sourceMap === true

const constants = Object.assign(
  {
    '$$BUILDTIME': new Date(),
    '$$COMMITHASH': optionalFile( '.commithash', 'unknown' ).trim(),
    '$$TARGET': TARGET,
    '$$VERSION': meta.version
  },
  config.constants || {}
)

Object.keys( constants ).forEach( keyword => {

  banner = banner.replace( keyword, constants[ keyword ] )

} )

let entry = `Source/${ TARGET }/index.js`

if ( config.entry ) {

  entry = config.entry

  if ( entry.charAt( 0 ) === '.' ) {

    entry = join( 'Source', TARGET, entry )

  }

}

if ( ! existsSync( entry ) ) {

  die( TARGET + `: Could not find the entry file '${ entry }'` )

}

rollup( {

  entry: entry,

  external: external.list,

  plugins: [

    progress(),

    resolver( {
      external: external.map,
      root: 'Source/' + TARGET,
      paths: 'Source'
    } ),

    replace( {
      sourceMap: sourceMap,
      values: constants
    } ),

    pegjs(),

    babel( require( '../babelrc' ) )

  ]

} )

.then( function bundler( bundle ) {

  let dest = config.dest || `${ TARGET }.js`

  function createBundle( format ) {

    bundle.write( {

      format, dest, banner, sourceMap

    } )

    .catch( die )

  }

  createBundle( config.format || 'cjs' )

  if ( config.esModule ) {

    if ( typeof config.esModule === 'string' ) {

      dest = config.esModule

    } else {

      dest = dest.replace( '.js', '.es.js' )

    }

    if ( sourceMap === true ) sourceMap = 'inline'

    createBundle( 'es' )

  }

} )

.catch( die )
