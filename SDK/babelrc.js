'use strict'

module.exports = {

  babelrc: false,

  only: new RegExp( __dirname ),

  plugins: [

    'transform-class-properties',

    'transform-export-extensions',

    'transform-object-rest-spread',

  ]

}
