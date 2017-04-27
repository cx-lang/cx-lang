#!/usr/bin/env node

"use strict";

const cxlang = require( "../" );
const { join, lstat } = cxlang.require( "file-system" );
const { die, log } = cxlang.require( "utils/console" );

const argv = process.argv.slice( 2 );
const cwd = process.cwd();

lstat( join( cwd, "makefile.cx" ) )

  .then( function run( { exists, isFile, path } ) {

      if ( ! exists() || ! isFile() )

          die( `cx-lang: Cannot find the file '${ path }'` );

      return cxlang.execute( path, { argv, cwd } );

  } )

  .then( function done( result ) {

      if ( typeof result === "string" ) log( result );

  } )

  .catch( die );
