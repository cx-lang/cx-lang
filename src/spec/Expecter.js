'use strict'

//
// Native functions.
//

const __hasOwnProperty = Object.prototype.hasOwnProperty
const __toString = Object.prototype.toString

//
// Builds default Expectation error message.
//

export function buildMessage( actual, expected ) {

  return `Expecting '${ expected }', returned '${ actual }'`

}

//
// Expectation error.
//

export class ExpectationError extends Error {

  constructor( actual, expected, message ) {

    super()

    this.name = 'ExpectationError'

    if ( arguments.length === 1 ) {

      this.message = actual

    } else {

      this.actual = actual
      this.expected = expected
      this.message = message || buildMessage( actual, expected )

    }

    if ( typeof Error.captureStackTrace === 'function' )

      Error.captureStackTrace( this, equal )

    else

      this.stack = ( new Error() ).stack

  }

}

//
// Strict equality ensurer, throws on fail.
//

export function equal( actual, expected, message ) {

  message = message || buildMessage( actual, expected )

  if ( actual !== expected )

    throw new ExpectationError( message )

}

//
// Expecter, a chain-able asserter.
//

export class Expecter {

  //
  // Constructors...
  //

  constructor( value ) {

    Object.defineProperty( this, 'value', { value } )

  }

  static expect( value ) {

    return new Expecter( value )

  }

  //
  // Builds a Expectation error message.
  //

  message( expected ) {

    return buildMessage( this.value, expected )

  }

  //
  // Simple check if `this.value` contains a property called `key`.
  //

  property( key, message ) {

    message = message || `Expecting to have property '${ key }'`

    equal( key in this.value, true, message )

    return this

  }

  //
  // Check if `this.value` contains it's own property called `key`.
  //

  own( key, message ) {

    message = message || `Expecting to have own property '${ key }'`

    equal( __hasOwnProperty.call( this.value, key ), true, message )

    return this

  }

  //
  // Ensure the value for the own property called `key` equals
  // the given `value`.
  //
  // If the given `value` is a function, execute it by passing
  // `message` as the context and the `this.value[ key ]` as a
  // new Expecter.
  //

  at( key, value, message ) {

    if ( typeof value === 'function' ) {

      this.own( key )

      value.call( message, new Expecter( this.value[ key ] ) )

    } else {

      message = message || `Expecting { '${ key }': '${ value }' }`

      equal( this.value[ key ], value, message )

    }

    return this

  }

  //
  // Assert if `this.value` strictly equals `expected`.
  //

  toEqual( expected, message ) {

    equal( this.value, expected, message )

    return this

  }

  //
  // Ensure the type is as expected.
  //

  typeof( target, message ) {

    const actual = __toString.call( this.value ).toLowerCase()
    const expected = `[object ${ target.toLowerCase() }]`

    equal( actual, expected, message )

    return this

  }

  //
  // Ensure the source equals `expected`.
  //

  toString( expected, message ) {

    equal( this.value.toString(), expected, message )

    return this

  }

}
