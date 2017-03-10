#!/usr/bin/env node

'use strict'

const minimist = require( 'minimist' )
const cxlang = require( '../' )
const { join, lstat } = cxlang.require( 'file-system' )
const { die } = cxlang.require( 'utils/console' )
const libcx = cxlang.require( 'package-manager' )

const argv = process.argv.slice( 2 )
const cwd = process.cwd()

lstat( join( cwd, 'package.json' ) )

  .then( function run( { exists, isFile, path } ) {

    if ( ! exists() || ! isFile() )

      die( `libcx: Cannot find the config file '${ path }'` )

    const command = argv.shift()
    const opts = minimist( argv )

    opts.config = require( path )
    opts.cwd = cwd

    return libcx( command, opts )

  } )

  .catch( die )
