/**
 * @typedef {Object} PosDetailsCache
 * @property {number} offset
 * @property {number} line
 * @property {number} column
 *
 * @typedef {Object} TrackerOptions
 * @property {string} filename
 * @property {PosDetailsCache[]} detailsCache
 */

/**
 * A custom position tracker.
 *
 * @param {string} input
 * @param {TrackerOptions} [options]
 */

export function create( input, options = {} ) {

    const _detailsCache = options.detailsCache || [ { offset: 0, line: 1, column: 1 } ];

    /**
     * @param {number} offset
     */

    function compute( offset ) {

        let details = _detailsCache[ offset ];
        let char, pos;

        if ( details ) return details;

        pos = offset - 1;
        while ( ! _detailsCache[ pos ] ) --pos;

        details = _detailsCache[ pos ];
        details = {
            offset: offset,
            line: details.line,
            column: details.column
        };

        while ( pos < offset ) {

            char = input.charCodeAt( pos );

            if ( char === 10 ) { // LF: \n

                ++details.line;
                details.column = 1;

            } else if ( char === 13 ) { // CRLF: \r\n

                ++details.line;
                details.column = 1;
                if ( input.charCodeAt( pos + 1 ) === 10 ) ++pos;

            } else {

                ++details.column;

            }

            ++pos;

        }

        _detailsCache[ offset ] = details;
        return details;

    }

    /**
     * @param {number} startPos
     * @param {number} endPos
     */

    function generate( startPos, endPos ) {

        return {
            filename: options.filename,
            start: compute( startPos ),
            end: compute( endPos )
        };

    }

    return { compute, generate };

}

/**
 * Default export
 */

export default {

    create

};
