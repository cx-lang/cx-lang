NODE_MODULES_BIN_DIR = ${CURDIR}/node_modules/.bin

PEGJS  = $(NODE_MODULES_BIN_DIR)/pegjs-dev
MOCHA  = $(NODE_MODULES_BIN_DIR)/mocha
ESLINT = $(NODE_MODULES_BIN_DIR)/eslint

PARSER_SRC  = src/parser.pegjs
MAIN_PARSER = lib/parser/default.js
ALT_PARSER  = lib/parser/alternative.js

all: clean build lint test

build: parser alt-parser

parser:
	$(PEGJS) $(PARSER_SRC) $(MAIN_PARSER)

alt-parser:
	$(PEGJS) --cache $(PARSER_SRC) $(ALT_PARSER)

test:
	$(MOCHA)

lint:
	$(ESLINT) --cache .

clean:
	rm -f $(MAIN_PARSER)
	rm -f $(ALT_PARSER)
	rm -f .eslintcache

.PHONY:  all build parser alt-parser test lint clean
.SILENT: all build parser alt-parser test lint clean
