import { existsSync, readFileSync } from "fs";

export function optionalFile( filename, alternativeContent = "" ) {

    if ( existsSync( filename ) ) {

        return readFileSync( filename, "utf8" );

    }

    return alternativeContent;

}
