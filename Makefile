PEGJS = ${CURDIR}/node_modules/.bin/pegjs-dev
MOCHA = ${CURDIR}/node_modules/.bin/mocha
ESLINT = ${CURDIR}/node_modules/.bin/eslint

PARSER_SRC = src/parser.pegjs
MAIN_PARSER = lib/main-parser.js
ALT_PARSER = lib/alt-parser.js

all: clean build test

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

.PHONY:  all build parser alt-parser test lint clean
.SILENT: all build parser alt-parser test lint clean
