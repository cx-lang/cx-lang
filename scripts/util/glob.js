"use strict";

const globby = require( "globby" );
const { join } = require( "path" );

/**
 * Find file-system entries that exist and match given patterns,
 * calling the callback on each entry found.
 *
 * @param {string|string[]} patterns
 * @param {function} callback
 * @param {object} [options]
 */

function glob( patterns, callback, options = {} ) {

    options.cwd = options.cwd || process.cwd();

    globby
      .sync( patterns, options )
      .forEach( match => {

          callback( join( options.cwd, match ), match );

      } );

}

/**
 * Run `glob`, wrapping `callback` in a `try..catch` block.
 *
 * @param {string|string[]} patterns
 * @param {function} callback
 * @param {object} [options]
 */

glob.attempt = function attempt( patterns, callback, options ) {

    glob( patterns, ( filename, id ) => {

        try {

            callback( filename, id );

        } catch ( error ) {

            console.error( error.stack || error.message || error );

        }

    }, options );

};

module.exports = glob;
