/* eslint eqeqeq: 0, no-self-compare: 0*/

const __toString = Object.prototype.toString;

export const isArray = Array.isArray;

export function isError( object ) {

    return object instanceof Error;

}

export function isNumber( object ) {

    return typeof object === "number" && object == object;

}

export const isFinite = Number.isFinite;

export function isFloat( n ) {

    return n === +n && n !== ( n | 0 );

}

export function isInfinity( n ) {

    if ( typeof n !== "number" ) return false;

    return n === Infinity || n === +Infinity || n === -Infinity;

}

export const isInteger = Number.isInteger;

export const isNaN = Number.isNaN;

export function isObject( object ) {

    return __toString.call( object ) === "[object Object]";

}

export function isRegExp( object ) {

    return __toString.call( object ) === "[object RegExp]";

}

export default function typeOf( object, target ) {

    const name = object != object ? "nan"
               : object instanceof Error ? "error"
               : __toString.call( object ).toLowerCase();

    if ( typeof target === "string" ) {

        return name === `[object ${ target.toLowerCase() }]`;

    }

    return name.substring( 8, name.length - 1 );

}
