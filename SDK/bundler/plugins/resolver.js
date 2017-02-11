'use strict'

const { existsSync, lstatSync } = require( 'fs' )
const { join } = require( 'path' )
const { addExtension, createFilter } = require( 'rollup-pluginutils' )

function resolveFilename( id ) {

  if ( existsSync( id ) ) {

    if ( ! lstatSync( id ).isDirectory() ) return id

    const indexFile = join( id, 'index.js' )

    if ( existsSync( indexFile ) ) return indexFile

  }

  const path = addExtension( id )

  return existsSync( path ) ? path : null

}

module.exports = function createPlugin( options = {} ) {

  const { root, paths, include, exclude, external = {} } = options

  const filter = createFilter( include, exclude )

  const otherPaths
    = Array.isArray( paths ) ? paths
    : typeof paths === 'string' ? [ paths ] : []

  return {

    name: 'resolver',

    resolveId( importee, importer ) {

      if ( ! filter( importee ) ) return null
      if ( ! importer || /\0/.test( importee ) ) return null
      if ( external[ importee ] ) return null

      let id = importee.replace( '\\', '/' )
      const searchPaths = []
      let startsWith = id.charAt( 0 )

      if ( startsWith === '/' ) {

        id = id.substr( 1 )
        startsWith = id.charAt( 0 )

      }

      if ( startsWith === '.' ) {

        searchPaths.push( join( importer, id ) )

      } else {

        if ( root ) searchPaths.push( join( root, id ) )

        for ( const path of otherPaths ) {

          if ( root ) searchPaths.push( join( root, path, id ) )

          searchPaths.push( join( path, id ) )

        }

        searchPaths.push( id )

      }

      for ( let path of searchPaths ) {

        path = resolveFilename( path )

        if ( path ) return path

      }

      return null

    }

  }

}
