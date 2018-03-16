/**
 * Extract an element from every array within the tail, while
 * pushing into the the new array that already has the head.
 *
 *      const head = 1;
 *      const tail = [ [ 2, 3 ], [ 4, 5 ] ];
 *      console.log( buildList( head, tail, 1 ) );
 *      > [ 1, 3, 5 ]
 *
 *      console.log( buildList( 1, [], 3 ) );
 *      > [ 1 ]
 *
 * @param {any} head
 * @param {array[]} tail
 * @param {number} index
 * @returns {any[]}
 */

export default function buildList( head, tail, index ) {

    const length = tail.length;
    const result = [ head ];
    let i = -1;

    if ( length === 0 ) return result;

    while ( ++i < length ) {

        result[ i + 1 ] = tail[ i ][ index ];

    }

    return result;

}
