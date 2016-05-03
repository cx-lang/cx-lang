NODE_MODULES_BIN_DIR = ${CURDIR}/node_modules/.bin

MOCHA  = $(NODE_MODULES_BIN_DIR)/mocha
ESLINT = $(NODE_MODULES_BIN_DIR)/eslint

all: clean lint test

clean:
	rm -f .eslintcache

lint:
	$(ESLINT) --cache .

test:
	$(MOCHA)

.PHONY:  all clean lint test
.SILENT: all clean lint test
