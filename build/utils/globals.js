const FS = require('fs-extra');
const PATH = require('path');

global.debug = require('debug')('cx-lang');
global.EOL = require('os').EOL;
global.basename = PATH.basename;
global.dirname = PATH.dirname;
global.extname = PATH.extname;
global.resolve = PATH.join;

global.MODULE_DIR = resolve(__dirname, '..', '..');
global.DIST_DIR = resolve(MODULE_DIR, 'dist');
global.LIB_DIR = resolve(MODULE_DIR, 'lib');
global.SRC_DIR = resolve(MODULE_DIR, 'src');


global.exists = function ( path ) {
  try {
    FS.lstatSync(path);
    return true;
  } catch ( err ) {
    if ( err.code !== 'ENOENT' ) throw err;
    return false;
  }
};

global.readFile = function ( filename ) {
  return FS.readFileSync(filename).toString();
};

global.writeFile = function ( filename, data ) {
  FS.mkdirpSync(dirname(filename));
  return FS.writeFileSync(filename, data);
};

const lstatsCache = {};
global.lstat = function ( path ) {
  const pname = PATH._makeLong(path);
  var stat = lstatsCache[pname];
  if ( !stat ) {
    stat = FS.lstatSync(path);
    stat.path = path;
    stat.basename = basename(path);
    stat.dirname = dirname(path);
    stat.extname = extname(path);
    lstatsCache[pname] = stat;
  }
  return stat;
};

global.walk = function ( path, callback ) {
  const stat = lstat(path);
  if ( stat.isDirectory() )
    FS.readdirSync(path).forEach(function(item){
      walk(resolve(path, item), callback);
    });
  else
    callback(path, stat);
};

const newLineChars = /(\n|\r\n|\r|\u2028|\u2029)/g;
global.indent = function ( data ) {
  return "  " + data.replace(newLineChars, function(m, nl){ return nl + "  "; });
};
