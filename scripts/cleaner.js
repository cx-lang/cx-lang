"use strict";

const glob = require( "./util/glob" );
const chalk = require( "chalk" );
const rimraf = require( "rimraf" );

glob.attempt( [

    "lib",
    "examples/**/output",
    ".eslintcache",
    "npm-debug.log"

], ( filename, id ) => {

    rimraf.sync( filename );
    console.log( chalk.grey( "Removed " + id ) );

} );
