parser:
	node build/parser

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
	rm -rf lib/compiler

.PHONY:  parser compiler test benchmark spec clean
.SILENT: parser compiler test benchmark spec clean
