"use strict";

if ( require.main === module ) process.exit( 0 );

module.exports = {

    "globals": {

        "WORKING_DIR": true,
        "OPTIONS": true,
        "PATHS": true,
        "SEPARATOR": true,

        "join": true,
        "exists": true,
        "exit": true,
        "relative": true,
        "mkdir": true,
        "writeFile": true,

        "die": true,
        "pathinfo": true,
        "forward": true,
        "lstat": true,
        "readFile": true,
        "readJSON": true,
        "writeJSON": true,
        "glob": true

    }

};
