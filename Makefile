GULP  = ${CURDIR}/node_modules/.bin/gulp

rebuild: clean build

clean:
	$(GULP) clean

clean-lib:
	$(GULP) clean:lib

clean-test:
	$(GULP) clean:test

build:
	$(GULP) build

build-lib:
	$(GULP) build:lib

build-test:
	$(GULP) build:test

.PHONY:  rebuild clean clean-lib clean-test build build-lib build-test
.SILENT: rebuild clean clean-lib clean-test build build-lib build-test
