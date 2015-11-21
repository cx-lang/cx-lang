MOCHA = ${CURDIR}/node_modules/.bin/mocha

build: clean parser lib dist

parser:
	node build/parser

pegjs:
	node build/parser --pegjsOnly

lib:
	node build/lib

dist:
	node build/dist

test:
	$(MOCHA)

clean:
	node build/clean

.PHONY:  build parser pegjs lib dist test clean
.SILENT: build parser pegjs lib dist test clean
