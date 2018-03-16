/**
 * Extract an element from an optional array.
 *
 *      const head = [ [ 1, 2 ], [ 3, 4 ] ];
 *      console.log( extractOptional( head, 0 ) );
 *      > [ 1, 2 ]
 *
 *      const tail = [ [ 5, 6 ], [ 7, 8 ] ];
 *      console.log( extractOptional( tail, 3 ) );
 *      > undefined
 *
 *      console.log( extractOptional( tail, 3, 'alt' ) );
 *      > 'alt'
 *
 * @param {any[]} [list]
 * @param {number} index
 * @param {any} [alternative]
 * @returns {any}
 */

export default function extractOptional( list, index, alternative ) {

    return list ? ( list[ index ] || alternative ) : alternative;

}
