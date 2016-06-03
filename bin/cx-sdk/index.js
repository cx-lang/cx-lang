#!/usr/bin/env node

const babel = require('babel-core');
const utils = require('../utils');
const { die, log, onArg, join } = utils;

var SRC = join(utils.CXLANG, 'src');
var OUTPUT = utils.CWD;

utils.usage = utils.readFile(join(__dirname, 'usage.txt'));
if ( utils.argc == 0 ) die();

onArg(['-s', '--silent'], ()=> utils.SILENT = true);
onArg(['--verbose'], ()=> utils.VERBOSE = true);

log('  - Checking if src argument is set, then checking if it exists...');
onArg(['--src'], (src)=>{
  SRC = join(utils.CWD, src);
  if ( !utils.isDirectory(SRC) ) {
    die('The supplied src directory is incorrect: ' + SRC);
  }
});

log('  - Ensuring the output directory exists...');
onArg(['--output'], (output)=>{
  OUTPUT = join(utils.CWD, output);
  if ( utils.isDirectory(OUTPUT) ) {
    utils.warn('  x The supplied output directory already exists: ' + OUTPUT);
  } else {
    utils.mkdirp(OUTPUT);
  }
});

const [ task, target ] = utils.argv[0].split('/');

log('  - Validating task...');
if ( task == 'help' || task == '?' ) die();
if ( task != 'build' && task != 'clean' ) {
  die('Unrecognized task specified: ' + task);
}

log('  - Validating target...');
if ( typeof target != 'string' || target == '' ) {
  die('To proceed you must specify a target to ' + task + '.');
}
if ( target != 'libcx' && target != 'examples' && target != 'test' ) {
  die('Unrecognized target specified: ' + target);
}

log('  - Loading and executing task...');
require(`./${ task }-${ target }`)(SRC, OUTPUT);
