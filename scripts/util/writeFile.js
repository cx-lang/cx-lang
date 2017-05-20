"use strict";

const fs = require( "fs" );

/**
 * A const object passed to `fs.writeFileSync`.
 */

const options = {
    "encoding": "utf8",
    "flag": "w",
    "mode": 0o666
};

/**
 * Write's data to a `utf8` file.
 *
 * @param {string} filename
 * @param {string|Buffer} data
 */

function writeFile( filename, data ) {

    fs.writeFileSync( filename, data, options );

}

module.exports = writeFile;
