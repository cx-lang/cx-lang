"use strict";

const fs = require( "fs" );

/**
 * Reads a `utf8` file.
 *
 * @param {string} filename
 */

function readFile( filename ) {

    return fs.readFileSync( filename, "utf8" );

}

module.exports = readFile;
