"use strict";

const globby = require( "globby" );
const Mocha = require( "mocha" );

require( "babel-register" )( {

    only: /cx-lang([\/|\\\\])src/

} );

const files = globby.sync( [ "src/**/*.{spec,test}.js" ] );

if ( files.length ) {

    const mocha = new Mocha( {

        "ui": "bdd",
        "reporter": "spec",
        "timeout": 5000,

    } );

    files.forEach( mocha.addFile );

    mocha.run( process.exit );

}
