"use strict";

const fs = require( "fs" );
const { sep } = require( "path" );

/**
 * A function that returns details about the given `path`.
 *
 * @param {string} path
 * @param {string} [cwd=process.cwd()]
 */

function pathinfo( path, cwd ) {

    const parts = path.split( sep );
    let STAT, ID;

    const info = {

        Path: path,
        Name: parts.pop(),
        Dir: parts.join( sep ),

        /**
         * Check if the given `path` exists.
         *
         * @returns {boolean}
         */

        exists() {

            return fs.existsSync( path );

        },

        /**
         * Returns the `stat` object for `path`
         *
         * @param {boolean} reloadStat
         * @returns {object}
         */

        stat( reloadStat ) {

            if ( reloadStat ) STAT = void 0;
            return STAT || fs.lstatSync( path );

        },

        /**
         * Returns a `Date` indicating the mtime.
         *
         * @param {boolean} reloadStat
         * @returns {Date}
         */

        mtime( reloadStat ) {

            if ( ! info.exists() ) return -1;
            return +info.stat( reloadStat ).mtime;

        },

        /**
         * Returns a forward-slashed path, with the current working directory removed.
         *
         * @returns {string}
         */

        id() {

            if ( ! ID ) ID = path

                .replace( cwd || process.cwd(), "" )
                .replace( /\\/g, "/" )
                .slice( 1 );

            return ID;

        },

        /**
         * Returns a boolean indicating if the given `path` is a file.
         *
         * @param {boolean} reloadStat
         * @returns {boolean}
         */

        isFile( reloadStat ) {

            return info.stat( reloadStat ).isFile();

        },

        /**
         * Returns the size of the file at `path`
         *
         * @param {boolean} reloadStat
         * @returns {number}
         */

        size( reloadStat ) {

            return info.stat( reloadStat ).size;

        }

    };

    return info;

}

module.exports = pathinfo;
