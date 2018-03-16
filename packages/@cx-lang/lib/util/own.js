/* eslint eqeqeq: 0*/

const __hasOwnProperty = Object.prototype.hasOwnProperty;

export default function own( object, key ) {

    if ( ! object ) return false;

    if ( ! object[ key ] ) return false;

    return __hasOwnProperty.call( object, key );

}
