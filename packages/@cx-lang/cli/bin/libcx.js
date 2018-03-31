"use strict";

const minimist = require( "minimist" );
const { join, lstat } = require( "@cx-lang/lib/fs" );
const { die, log } = require( "@cx-lang/lib/console" );
const pm = require( "@cx-lang/package-manager" );

const argv = process.argv.slice( 2 );
const cwd = process.cwd();

lstat( join( cwd, "cargo.toml" ) )

    .then( function run( { exists, isFile, path } ) {

        if ( ! exists() || ! isFile() )

            die( `libcx: Cannot find '${ path }'` );

        const command = argv.shift();
        const opts = minimist( argv );

        if ( opts.cwd === "." ) delete opts.cwd;

        opts.config = require( path );
        opts.cwd = opts.cwd || cwd;

        return pm( command, opts );

    } )

    .then( function done( result ) {

        if ( typeof result === "string" ) log( result );

    } )

    .catch( die );
