SDK = node bin/cx-sdk

rebuild: clean build

clean: clean/test clean/examples clean/libcx

clean/%:
	@ $(SDK) $@

build: build/libcx build/examples build/test

build/%:
	@ $(SDK) $@

test: spec benchmark

spec:
	node test/spec

benchmark:
	node test/benchmark

.PHONY:  rebuild clean build test spec benchmark
.SILENT: rebuild clean build test spec benchmark
