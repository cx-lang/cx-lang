var fs = require('fs-extra');
var path = require('path');
var UglifyJS = require('uglify-js');

var __hasOwnProperty = Object.prototype.hasOwnProperty;

global.rm = require('rimraf').sync;
global.mkdir = require('mkdirp').sync;
exports.glob = require("glob").sync;
global.exec = require('child_process').exec;

global.exists = fs.existsSync;
global.basename = path.basename;
global.dirname = path.dirname;
global.extname = path.extname;
global.join = path.join;
global.resolve = path.resolve;

global.ROOT_DIR = join(__dirname, '..');
global.BIN_DIR = join(ROOT_DIR, 'bin');
global.BUILD_DIR = __dirname;
global.DIST_DIR = join(ROOT_DIR, 'dist');
global.SRC_DIR = join(ROOT_DIR, 'src');
global.TEST_DIR = join(ROOT_DIR, 'test');

global.argv = process.argv.slice(2);
global.argc = argv.length;
global.print = console.log;
global.exit = process.exit;
global.abort = function ( ) {
  print.apply(null, arguments);
  exit(1);
};

global.readFile = function ( filename ) {
  return fs.readFileSync(filename).toString();
};

global.writeFile = function ( filename, data ) {
  mkdir(dirname(filename));
  return fs.writeFileSync(filename, data);
};

global.lstat = function ( path ) {
  var stat = fs.lstatSync(path);
  stat.path = path;
  stat.basename = basename(path);
  stat.dirname = dirname(path);
  stat.extname = extname(path);
  return stat;
};

global.walk = function ( path, callback ) {
  var stat = lstat(path);
  if ( stat.isDirectory() )
    fs.readdirSync(path).forEach(function(item){
      walk(join(path, item), callback);
    });
  else
    callback(path, stat);
};

global.readdir = function ( path ) {
  var files = {};
  walk(path, function(filename, stat){
    files[filename] = stat;
  });
  return files;
};/*

global.readdir = function ( path, deep ) {
  var stat = lstat(path), items = [];
  if ( stat.isDirectory() )
    return fs.readdirSync(path).map(function(item){
      item = lstat(join(path, item));
      if ( item.isDirectory() && deep ) {
        [].push.apply(items, readdir(item.path, true));
      }
      return item;
    }).concat(items);
  else
    return [stat];
};*/

global.minify = function ( data ) {
  return UglifyJS.minify(data, { fromString: true }).code;
};

exports.str_repeat = function ( string ) {
  var output = "", times = typeof arguments[1] === 'number' ? arguments[1] : 2;
  while ( times > 0 ) {
    output += string;
    --times;
  }
  return output;
};

var newLineChars = /(\n|\r\n|\r|\u2028|\u2029)/g;
global.indent = function ( data, tabs ) {
  return (tabs || "  ") + data.replace(newLineChars, function(m, nl){ return nl + (tabs || "  "); });
};

global.slice = function ( object, from, to ) {
  return Array.isArray(object) ? object.slice(from || 0, to) : object.substring(from, to || object.length);
};

global.has = function ( object, key ) {
  return object && __hasOwnProperty.call(object, key);
};

exports.each = function ( object, iterator, context ) {
  if ( Array.isArray(object) )
    object.forEach(iterator, context);
  else
    for ( var key in object ) {
      if ( object.hasOwnProperty(object, key) ) {
        iterator.call(context, object[key], key, object);
      }
    }
};

global.merge = function ( target, source ) {
  var key, isArray = Array.isArray(target);
  if ( isArray && Array.isArray(source) ) {
    [].push.apply(target, source);
  } else {
    for ( key in source ) {
      if ( source.hasOwnProperty(key) ) {
        target[isArray ? target.length : key] = source[key];
      }
    }
  }
  return target;
};

global.str_replace = function ( string, dictionary ) {
  each(dictionary, function(value, key){
    if ( value === null || value === void 0 ) value = "";
      if ( typeof key === 'string' ) {
        key = new RegExp(key, 'g');
      }
      string = string.replace(key, value);
  });
  return string;
};
