/* globals options, location, peg$savedPos, peg$currPos */

var __CX_API__ = 0;
  
var loc = function ( ast ) { return ast; };
if ( options.loc ) {
  if ( typeof options.loc === 'function' ) {
    loc = function ( ast ) {
      return options.loc(ast, peg$savedPos, peg$currPos);
    };
  } else {
    loc = function ( ast ) {
      var position = location();
      ast.loc = {
        filename: options.filename,
        start: position.start,
        end: position.end,
        range: [peg$savedPos, peg$currPos]
      };
      return ast;
    };
  }
}

function extractList ( list, index ) {
  var result = [], i, length = list.length;
  for ( i = 0; i < length; ++i ) {
    result[i] = list[i][index];
  }
  return result;
}

function buildList ( first, rest, index ) {
  return [first].concat(extractList(rest, index));
}

function buildTree ( first, rest, builder ) {
  var result = first, i, length = rest.length;
  for ( i = 0; i < length; ++i ) {
    result = builder(result, rest[i]);
  }
  return result;
}
