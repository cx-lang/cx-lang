/* eslint no-use-before-define: 0 */

"use strict";

/* --------- 1) Dependencies ---------*/

const glob = require( "./util/glob" );
const pathinfo = require( "./util/pathinfo" );
const readFile = require( "./util/readFile" );
const writeFile = require( "./util/writeFile" );
const { compiler, GrammarError, parser } = require( "pegjs-dev" );
const { findRule } = require( "pegjs-dev/lib/compiler/asts" );
const toCamelCase = require( "camelcase" );
const chalk = require( "chalk" );
const prettysize = require( "prettysize" );
const mkdirp = require( "mkdirp" );
const { EOL } = require( "os" );
const { join, relative } = require( "path" );

/* --------- 2) Options ---------*/

const patterns = [ "**/*.pegjs", "**/*.util.js" ];
const srcDir = join( __dirname, "..", "src", "cx-lang", "language" );
const outDir = join( __dirname, "..", "lib", "cx-lang", "language" );

const options = {

    allowedStartRules: [ "start" ],
    cache: false,
    format: "commonjs",
    optimize: "speed",
    output: "source",
    trace: false

};

/* --------- 3) Utility Methods ---------*/

const parentTypes = {

    "grammar": "rules",
    "choice": "alternatives",
    "sequence": "elements"

};

function nicesize( n ) {

    return prettysize( n, 0, 0, 2 ).replace( ".00", "" );

}

function die( err ) {

    if ( err.location && err.message ) console.error( err.message );
    else console.error( err.stack || err.message || err );

    process.exit( 1 );

}

function rewriteLocations( node, filename ) {

    if ( node.location ) node.location.filename = filename;

    const children = node[ parentTypes[ node.type ] ];

    if ( children )

        children.forEach( child => rewriteLocations( child, filename ) );

    else if ( node.expression )

        rewriteLocations( node.expression, filename );

}

const PREDEFINED_RULE = /Rule "(.*)" is already defined/;
function buildErrorMessage( error, ast ) {

    const { filename, start } = error.location;
    let message = error.message;

    const position = ( filename ? `In "${ filename }", at ` : "At " )
                   + `Line ${ start.line }, Column ${ start.column }`;

    let results = PREDEFINED_RULE.exec( message );
    if ( ast && results ) {

        results = findRule( ast, results[ 1 ] );
        if ( results ) {

            results = results.location.filename;
            if ( results !== filename ) {

                message = message.slice( 0, -1 ) + ` of "${ results }"`;

            }

        }

    }

    PREDEFINED_RULE.lastIndex = -1;
    return position + " :\n\n" + message;

}

function parse( filename ) {

    try {

        const source = readFile( filename );

        if ( source.trim().length === 0 ) return { rules: [] };

        return parser.parse( source );

    } catch ( error ) {

        if ( error.location ) {

            error.location.filename = pathinfo( filename ).id();
            error.message = buildErrorMessage( error );

        }

        die( error );

    }

}

function compile( ast ) {

    try {

        return compiler.compile( ast, convertedPasses, options ) + EOL;

    } catch ( error ) {

        if ( error.name === "GrammarError" ) {

            error.message = buildErrorMessage( error, ast );

        }

        die( error );

    }

}

/* --------- 4) Pre-generation tasks ---------*/

const dummyLocation = {

    filename: __filename,
    start: { offset: 0, line: 0, column: 0 },
    end: { offset: 0, line: 0, column: 0 }

};

const convertedPasses = {

    check: [

        compiler.passes.check.reportUndefinedRules,
        compiler.passes.check.reportDuplicateRules,
        compiler.passes.check.reportDuplicateLabels,
        compiler.passes.check.reportInfiniteRecursion,
        compiler.passes.check.reportInfiniteRepetition

    ],

    transform: [

        compiler.passes.transform.removeProxyRules

    ],

    generate: [

        compiler.passes.generate.generateBytecode,
        compiler.passes.generate.generateJS

    ]

};

/* --------- 5) Generate parser ---------*/

const targets = {};
const rules = [ false ];
let code = "";
const dependencies = [];

glob( patterns, filename => {

    const source = pathinfo( filename, srcDir );
    const id = source.id();
    const size = nicesize( source.size() );

    if ( source.Name.endsWith( ".util.js" ) ) {

        dependencies.push( id );

        console.log(

            `  - ${ chalk.yellow( id ) }` +
            chalk.grey( `(${ size })` )

        );

        return true;

    }

    const grammar = parse( filename );
    rewriteLocations( grammar, id );

    const initializer = grammar.initializer ? grammar.initializer.code : false;
    if ( typeof initializer === "string" && initializer.trim().length > 0 ) {

        code += `\n// ${ id }\n\n${ initializer }\n`;

    }

    grammar.rules.forEach( rule => {

        if ( rule.name !== "start" ) return rules.push( rule );

        if ( targets[ id ] ) {

            const previous = targets[ id ].location.start;

            console.warn( new GrammarError(
                `Rule "start" was previously defined `
                + `at line ${ previous.line }, `
                + `column ${ previous.column } `
                + `in "${ id }"`,
                rule.location
            ) );

        } else {

            targets[ id ] = rule;

        }

    } );

    let count = grammar.rules.length + " rule";
    if ( grammar.rules.length !== 1 ) count += "s";

    console.log(

        `  ${ targets[ id ] ? ">" : "-" } ${ chalk.cyan( id ) }` +
        chalk.grey( `(${ count }, ${ size })` )

    );

}, { cwd: srcDir } );

const targetids = Object.keys( targets );
if ( targetids.length > 0 ) {

    console.log( "" );
    targetids.forEach( id => {

        const filename = join( outDir, id.replace( ".pegjs", ".js" ) );
        const target = pathinfo( filename );
        rules[ 0 ] = targets[ id ];

        options.filename = id;
        options.dependencies = {};

        dependencies.forEach( dependency => {

            const name = dependency.split( "/" ).pop().slice( 0, -8 );
            dependency = relative( target.Dir, join( outDir, dependency ) );

            options.dependencies[ toCamelCase( name ) ] = dependency.replace( /\\/g, "/" );

        } );

        const ast = {

            type: "grammar",
            initializer: {
                type: "initializer",
                code,
                location: dummyLocation
            },
            rules,
            location: dummyLocation

        };

        mkdirp.sync( target.Dir );
        writeFile( filename, compile( ast ) );

        const size = nicesize( target.size( 1 ) );
        console.log(

            chalk.green( "Generated " ) +
            chalk.magenta( target.id() ) +
            chalk.grey( `(${ size })` )

        );

    } );

}
