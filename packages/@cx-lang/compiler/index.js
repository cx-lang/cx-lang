/* eslint no-unused-vars: 0 */

import * as fs from "cx-lang/file-system";
import { Package } from "cx-lang/language";

export default async function main( cwd, options ) {

    console.log( await fs.optionalFile( "VERSION" ) );

}
