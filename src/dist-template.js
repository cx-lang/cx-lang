/*
  Copyright (c) 2014-2015 Futago-za Ryuu <futagoza.ryuu@gmail.com>
  https://github.com/cx-lang/cx-lang, v__VERSION__
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
*/
/* globals this, define, module, exports, Error */
(function(root){

  // local variables
  var modules, cache = {};

  // simulates a module importer
  function require ( id ) {
    var module = cache[id];
    if ( !module ) {
      if ( typeof modules[id] !== "function" ) {
        throw new Error("cannot find module '" + id + "'");
      }
      module = cache[id] = { exports: {} };
      modules[id](module, module.exports);
    }
    return module.exports;
  }
  
  // cx-lang modules
  modules = {
    
__MODULES__
    
  };

  // Universal Module Definition (UMD) to support AMD, CommonJS/Node.js, Rhino, and plain browser loading
  var cx = require('cx/lib/browser');
  if ( typeof define === 'function' ) {
    function factory ( ) { return cx; };
    if ( define.amd ) define(factory);
    else define('cx-lang', [], factory);
  } else {
    if ( typeof exports !== 'undefined' ) {
      if ( typeof module !== 'undefined' ) {
        module.exports = cx;
      }
      exports.cx = cx;
    } else {
      root['CXLang'] = cx;
    }
  }

})(this);
