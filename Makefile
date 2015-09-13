parser:
	node build/parser

pegjs:
	node build/parser --pegjsOnly

compiler:
	node build/compiler

test:
	node test

benchmark:
	node test/benchmark

spec:
	node test/spec

clean:
	rm -f lib/parser.js
	rm -f src/parser.pegjs
	rm -rf lib/compiler

.PHONY:  parser pegjs compiler test benchmark spec clean
.SILENT: parser pegjs compiler test benchmark spec clean
