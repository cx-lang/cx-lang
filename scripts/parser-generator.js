#!/usr/bin/env node

'use strict'

/*--------- 1) Dependencies ---------*/

require( './globalHelpers' )

const globby = require( 'globby' )
const { compiler, GrammarError, parser } = require( 'pegjs-dev' )
const { findRule } = require( 'pegjs-dev/lib/compiler/asts' )
const { relative } = require( 'path' )
const toCamelCase = require( 'camelcase' )

/*--------- 2) Options ---------*/

const srcDir = join( srcDir, 'src', 'cx-lang', 'language' )
const outDir = join( srcDir, 'lib', 'cx-lang', 'language' )
const patterns = [ '**/*.pegjs', '**/*.util.js' ]

const options = {

  allowedStartRules: [ 'start' ],
  cache: false,
  format: 'commonjs',
  optimize: 'speed',
  output: 'source',
  trace: false

}

/*--------- 3) Utility Methods ---------*/

const parentTypes = {

  'grammar': 'rules',
  'choice': 'alternatives',
  'sequence': 'elements'

}

function rewriteLocations( node, filename ) {

  if ( node.location ) node.location.filename = filename

  const children = node[ parentTypes[ node.type ] ]

  if ( children )

    children.forEach( child => rewriteLocations( child, filename ) )

  else if ( node.expression )

    rewriteLocations( node.expression, filename )

}

const PREDEFINED_RULE = /Rule "(.*)" is already defined/
function buildErrorMessage( error, ast ) {

  const { filename, start } = error.location

  const position = ( filename ? `In "${ filename }", at ` : 'At ' )
                 + `Line ${ start.line }, Column ` + start.column

  let results = PREDEFINED_RULE.exec( error.message )
  if ( results ) {

    results = findRule( ast, results[ 1 ] )
    if ( results ) {

      results = results.location.filename
      if ( results !== filename ) {

        error.message = error.message.slice( 0, -1 ) + ` of "${ results }"`

      }

    }

  }

  PREDEFINED_RULE.lastIndex = -1
  return position + ' :\n\n' + error.message

}

function compile( ast ) {

  try {

    return compiler.compile( ast, convertedPasses, options )

  } catch ( error ) {

    if ( error.name === 'GrammarError' ) {

      error.message = buildErrorMessage( error, ast )

    }

    throw error

  }

}

/*--------- 4) Pre-generation tasks ---------*/

const dummyLocation = {

  filename: __filename,
  start: { offset: 0, line: 0, column: 0 },
  end: { offset: 0, line: 0, column: 0 }

}

const convertedPasses = {

  check: [

    compiler.passes.check.reportUndefinedRules,
    compiler.passes.check.reportDuplicateRules,
    compiler.passes.check.reportDuplicateLabels,
    compiler.passes.check.reportInfiniteRecursion,
    compiler.passes.check.reportInfiniteRepetition

  ],

  transform: [

    compiler.passes.transform.removeProxyRules

  ],

  generate: [

    compiler.passes.generate.generateBytecode,
    compiler.passes.generate.generateJS

  ]

}

/*--------- 5) Generate parser ---------*/

globby( patterns, { src: srcDir } )

  .catch( die )

  .then( files => {

    if ( files.length === 0 ) return null

    const targets = {}
    const rules = [ false ]
    let code = ''
    const dependencies = []

    let id, filename, grammar, source

    for ( id of files ) {

      id = id.replace( '/', SEPARATOR )
      filename = join( srcDir, id )

      if ( id.endsWith( '.util.js' ) ) {

        dependencies.push( id )

        console.log( `  - ${ forward( filename ) }` )
        continue

      }

      grammar = parser.parse( readFile( filename ) )

      rewriteLocations( grammar, id )

      source = grammar.initializer ? grammar.initializer.code : false
      if ( typeof source === 'string' && source.trim().length > 0 ) {

        code += `\n// ${ forward( id ) }\n\n${ source }\n`

      }

      grammar.rules.forEach( rule => {

        if ( rule.name !== 'start' ) return rules.push( rule )

        if ( targets[ id ] ) {

          const previous = targets[ id ].location.start

          throw new GrammarError(
            `Rule "start" was previously defined `
              + `at line ${ previous.line }, `
              + `column ${ previous.column } `
              + `in "${ id }"`,
            rule.location
          )

        }

        targets[ id ] = rule

      } )

      console.log( `  - ${ forward( filename ) }` )

    }

    console.log( '' )
    Object.keys( targets ).forEach( id => {

      const filename = join( outDir, id.replace( '.pegjs', '.js' ) )
      rules[ 0 ] = targets[ id ]

      options.filename = id
      options.dependencies = {}

      dependencies.forEach( dependency => {

        const name = pathinfo( dependency ).name.slice( 0, -8 )
        dependency = relative( filename, join( outDir, dependency ) )

        options.dependencies[ toCamelCase( name ) ] = dependency

      } )

      const ast = {

        type: 'grammar',
        initializer: {
          type: 'initializer',
          code,
          location: dummyLocation
        },
        rules,
        location: dummyLocation

      }

      mkdir( pathinfo( filename ).dir )
      writeFile( filename, compile( ast ) )
      console.log( `Generated ${ filename }` )

    } )

  } )