"use strict";

const globby = require( "globby" );
const Mocha = require( "mocha" );

const files = globby.sync( [ "lib/spec/**/*.{spec,test}.js" ] );

if ( files.length ) {

    const mocha = new Mocha( {

        "ui": "bdd",
        "reporter": "spec",
        "timeout": 30000

    } );

    files.forEach( mocha.addFile );

    mocha.run( process.exit );

}
