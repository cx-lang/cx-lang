import { join } from "path";

const _require = module.require;

export function require( id ) {

    return _require( join( __dirname, id ) );

}
