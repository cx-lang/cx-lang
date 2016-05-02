module.exports = function ( ast, options ) {
  return "module.exports = " + JSON.stringify(ast, null, "  ");
};
