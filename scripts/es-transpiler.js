"use strict";

/* --------- 1) Dependencies ---------*/

const glob = require( "./util/glob" );
const pathinfo = require( "./util/pathinfo" );
const readFile = require( "./util/readFile" );
const writeFile = require( "./util/writeFile" );
const babel = require( "babel-core" );
const chalk = require( "chalk" );
const mkdirp = require( "mkdirp" );
const { EOL } = require( "os" );
const { join, relative } = require( "path" );

/* --------- 2) Options ---------*/

const srcDir = join( __dirname, "..", "src" );
const outDir = join( __dirname, "..", "lib" );

const babelrc = JSON.parse( readFile( join( srcDir, ".babelrc" ) ) );

/* --------- 3) Transpile... ---------*/

glob.attempt( [ "**/*.js" ], ( filename, id ) => {

    const source = pathinfo( filename );
    const target = pathinfo( join( outDir, id ) );

    if ( ! source.isFile() ) return false;
    if ( target.exists() && source.mtime() < target.mtime() ) return false;

    const relativeName = relative( target.Dir, filename );
    babelrc.filename = filename;
    babelrc.filenameRelative = relativeName;
    babelrc.sourceFileName = relativeName;
    babelrc.sourceMapTarget = relativeName;
    babelrc.sourceRoot = relative( target.Dir, source.Dir );

    const input = readFile( filename );
    const output = babel.transform( input, babelrc );

    mkdirp.sync( target.Dir );
    writeFile( target.Path, `${ output.code + EOL + EOL }//# sourceMappingURL=${ source.Name }.map${ EOL }` );
    writeFile( target.Path + ".map", JSON.stringify( output.map, null, "  " ) + EOL );

    const base = input.length;
    const peak = output.code.length;
    const percentage = Math.round( ( ( peak - base ) / base ) * 100 );
    let note;

    if ( base < peak )

        note = chalk.red( percentage + "% bigger" );

    else

        note = chalk.green( -percentage + "% smaller" );

    console.log( source.id() + " -> " + target.id() + " " + note );

}, { cwd: srcDir } );
