MOCHA = ${CURDIR}/node_modules/.bin/mocha

build: clean parser lib dist

parser:
	node build/parser

lib:
	node build/lib

dist:
	node build/dist

test:
	$(MOCHA)

clean:
	node build/clean

.PHONY:  build parser lib dist test clean
.SILENT: build parser lib dist test clean
