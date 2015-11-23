PEGJS = ${CURDIR}/node_modules/.bin/pegjs
MOCHA = ${CURDIR}/node_modules/.bin/mocha

PARSER_OUTPUT  = lib/parser.js

build: parser

parser:
	$(PEGJS) src/parser.pegjs $(PARSER_OUTPUT)

test:
	$(MOCHA)

clean:
	rm -f $(PARSER_OUTPUT)

.PHONY:  build parser test clean
.SILENT: build parser test clean
