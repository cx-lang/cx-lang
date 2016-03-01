const parser = require("./main-parser");
const cparser = require("./alt-parser");

exports.MainParser = parser;
exports.AltParser = cparser;

exports.parse = ( code, options ) => {
  options = options || {};
  if ( options.alt ) {
    return cparser.parse(code, options);
  }
  return parser.parse(code, options);
};
