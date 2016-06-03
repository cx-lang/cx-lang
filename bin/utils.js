const fs = require('fs-extra');
const path = require('path');

const argv = process.argv.slice(2);
const exit = process.exit;
const print = console.log;

var tabbed, tab = ( ) => {
  if ( !tabbed ) {
    print("");
    tabbed = true;
  }
  return true;
};

exports = module.exports = {

  CXLANG: path.join(__dirname, '..'),
  CWD: process.cwd(),
  SILENT: false,
  VERBOSE: false,

  argv,
  argc: argv.length,
  exit,
  print,

  usage: '',
  die ( message ) {
    if ( !exports.SILENT ) {
      if ( message ) print("\n  " + message);
      print(exports.usage);
    }
    exit(message ? 1 : 0);
  },

  log ( ) {
    if ( !exports.SILENT && exports.VERBOSE ) tab() && print(...arguments);
  },
  warn ( ) {
    if ( !exports.SILENT ) tab() && console.warn(...arguments);
  },
  error ( ) {
    if ( !exports.SILENT ) tab() && console.error(...arguments);
    exit(1);
  },

  onArg ( args, callback ) {
    var i, length = args.length, index;
    for ( i = 0; i < length; ++i ) {
      index = argv.indexOf(args[i]);
      if ( index != -1 ) {
        callback(argv[index + 1]);
        break;
      }
    }
  },

  writeFile: fs.writeFileSync,
  readFile: filename => fs.readFileSync(filename, 'utf8'),
  emptyDir: fs.emptydirSync,
  mkdirp: fs.mkdirsSync,
  join: path.join

};

[ 'isFile', 'isDirectory' ].forEach(method => {

  exports[method] = ( filename ) => {
    try {
      return fs.lstatSync(filename)[method]();
    } catch ( err ) {
      if ( err.code && err.code == 'ENOENT' ) return false;
      throw err;
    }
  };

});
