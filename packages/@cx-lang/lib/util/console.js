import { EOL } from "os";
import { format } from "util";

export function print( ...args ) {

    process.stdout.write( format( ...args ) );

}

export function log( ...args ) {

    process.stdout.write( format( ...args ) + EOL );

}

export function error( ...args ) {

    process.stderr.write( format( ...args ) );

}

export function die( ...args ) {

    process.stderr.write( format( ...args ) );
    console.exit( 1 );

}
