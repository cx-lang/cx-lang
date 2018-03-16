import captureStackTrace from "cx-lang/utils/captureStackTrace";
import * as Module from "./implementations/cxlang/Module";
import * as Program from "./implementations/cxlang/Program";
import * as Script from "./implementations/cxlang/Script";

// All of the above parsers use the same `SyntaxError` function
// so it doesn't matter which one we use here.
export const SyntaxError = Module.SyntaxError;

export function buildErrorMessage( error ) {

    const { filename, start } = error.location;

    return ( filename ? `In "${ filename }", at ` : "At " )
         + `Line ${ start.line }, Column ` + start.column
         + " :\n\n" + error.message;

}

export const module = createParser( Module );
export const program = createParser( Program );
export const script = createParser( Script );

// @private
function createParser( parser ) {

    return function parse( source, options ) {

        try {

            return parser.parse( source, options );

        } catch ( error ) {

            if ( error.name === "SyntaxError" ) {

                error.message = buildErrorMessage( error );

            }

            captureStackTrace( error, parse );

            throw error;

        }

    };

}
