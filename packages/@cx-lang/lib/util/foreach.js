/* eslint padded-blocks: 0, brace-style: 0*/

const __hasOwnProperty = Object.prototype.hasOwnProperty;

function tryCatch( callback, context ) {

    try { callback.call( context, context.entry ) }

    catch ( error ) { return error }

}

export default function foreach( object, callback ) {

    let number = 0;
    let key, length, result, error;

    const BREAK = Symbol( "break" );
    const CONTINUE = Symbol( "continue" );

    const entry = [];

    Object.defineProperties( entry, {

        length: { get() { return 3 } },

        0: { get() { return object[ key ] } },

        1: { get() { return key } },

        2: { get() { return object } },

        number: { get() { return number } },

        index: { get() { return number - 1 } },

        key: { get() { return key } },

        value: { get() { return object[ key ] } },

        object: { get() { return object } }

    } );

    const context = {

        get entry() { return entry },

        break() { throw BREAK },

        continue() { throw CONTINUE },

        return( r ) {

            result = r;
            throw BREAK;

        }

    };

    function iterate() {

        ++number;

        error = tryCatch( callback, context );

        if ( ! error || error === CONTINUE ) return false;

        if ( error === BREAK ) return true;

        throw error;

    }

    if ( Array.isArray( object ) ) {

        length = context.length = object.length;

        for ( key = 0; key < length; ++key ) {

            if ( iterate() ) break;

        }

    } else {

        for ( key in object ) {

            if ( ! __hasOwnProperty.call( object, key ) ) continue;

            if ( iterate() ) break;

        }

    }

    return result;

}
