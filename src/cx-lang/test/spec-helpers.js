const assert = require( "assert" );
const own = require( "cx-lang/utils/own" );

export function visitAST( ast, options = {} ) {

    const parent = options.parent;

    return {

        ensureProperty( key ) {

            assert( own( ast, key ) );
            return this;

        },

        ensureField( key, value ) {

            assert( own( ast, key ) );
            assert.equal( ast[ key ], value );
            return this;

        },

        ensure( callback ) {

            callback.call( this, this );
            return this;

        },

        visit( key, callback ) {

            this.ensureProperty( key );
            options.parent = this;
            const child = visitAST( ast[ key ], options );
            if ( typeof callback === "function" ) {

                child.ensure( callback );
                return this;

            }
            return child;

        },

        leave() {

            return parent;

        }

    };

}

export function parseGrammar( code, options = {} ) {

    options.alt = options.alt === true;

    let ast = typeof code === "string" ? cxlang.parse( code, options ) : code;
    const element = options.element;

    if ( typeof element === "number" ) {

        if ( element > 0 ) ast = ast.elements[ element ];

    }

    return visitAST( ast, options );

}

export function parseElement( code, options = {} ) {

    options.element = options.element || 0;

    return parseGrammar( code, options );

}
