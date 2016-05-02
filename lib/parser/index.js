"use strict";

const Default = require('./default');
const Alternative = require('./alternative');

exports.Default = Default;
exports.Alternative = Alternative;

function buildErrorMessage ( error ) {
  var position = "", location = error.location;
  if ( location.filename ) {
    position += "In '" + location.filename + "', at "
  } else {
    position += "At ";
  }
  location = location.start;
  position += "Line " + location.line + ", ";
  position += "Column " + location.column;
  return position + ":\n\n" + error.message;
}

exports.parse = function ( code, options ) {
  options = options || {};
  try {
    if ( options.alt == true ) {
      return Alternative.parse(code, options);
    }
    return Default.parse(code, options);
  } catch ( error ) {
    if ( error.message && error.location ) {
      if ( !error.location.filename ) {
        error.location.filename = options.filename;
      }
      error.message = buildErrorMessage(error);
    }
    throw error;
  }
};
