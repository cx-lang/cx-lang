parser:
	node build/parser

compiler:
	node build/compiler

dist:
	node build/dist

test:
	node test

benchmark:
	node test/benchmark

spec:
	node test/spec

clean:
  rm -f lib/parser.js
	rm -rf lib/compiler
	rm -rf dist

.PHONY:  parser compiler dist test benchmark spec clean
.SILENT: parser compiler dist test benchmark spec clean
