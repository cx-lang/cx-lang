#!/usr/bin/env node

"use strict";

const cxlang = require( "@cx-lang/core" );
const { join, lstat } = require( "@cx-lang/lib/fs" );
const { die, log } = require( "@cx-lang/lib/console" );

const argv = process.argv.slice( 2 );
const cwd = process.cwd();

lstat( join( cwd, "cargo.toml" ) )

  .then( function run( { exists, isFile, path } ) {

      if ( ! exists() || ! isFile() )

          die( `cx-lang: Cannot find '${ path }'` );

      return cxlang.execute( { argv, cwd, path } );

  } )

  .then( function done( result ) {

      if ( typeof result === "string" ) log( result );

  } )

  .catch( die );
