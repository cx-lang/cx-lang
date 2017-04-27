
"use strict";

/* --------- 1) Dependencies ---------*/

require( "./globalHelpers" );

const Mocha = require( "mocha" );

/* --------- 2) Options ---------*/

let mochaopts = {

    "ui": "bdd",
    "reporter": "spec",
    "timeout": 30000

};

let patterns = [ "**/*.{spec,test}.js" ];
WORKING_DIR = join( WORKING_DIR, "lib", "spec" );

if ( process.argv.length > 2 ) {

    mochaopts = Object.assign( mochaopts, OPTIONS );

    if ( PATHS ) {

        patterns = PATHS;
        WORKING_DIR = process.cwd();

    }

}

/* --------- 3) Run tests ---------*/

/* global mocha*/ global.mocha = new Mocha( mochaopts );

glob( patterns, ( filename, id ) => {

    ( id.endsWith( ".spec.js" ) ? require : mocha.addFile )( filename );

} );

mocha.run( process.exit );
