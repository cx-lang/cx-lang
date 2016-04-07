"use strict";

const Default = require('./default');
const Alternative = require('./alternative');

exports.Default = Default;
exports.Alternative = Alternative;

exports.parse = function ( code, options ) {
  options = options || {};
  if ( options.alt == true ) {
    return Alternative.parse(code, options);
  }
  return Default.parse(code, options);
};
