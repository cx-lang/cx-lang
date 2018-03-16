/**
 * Extract an element from every array within the list, returning a new array.
 *
 *      const tail = [ [ 1, 2 ], [ 3, 4 ] ];
 *      console.log( extractList( tail, 0 ) );
 *      > [ 1, 3 ]
 *
 *      console.log( extractList( [], 3 ) );
 *      > []
 *
 * @param {array[]} list
 * @param {number} index
 * @returns {any[]}
 */

export default function extractList( list, index ) {

    const length = list.length;
    if ( length === 0 ) return [];

    let i = -1;
    const result = [];

    while ( ++i < length ) {

        result[ i ] = list[ i ][ index ];

    }

    return result;

}