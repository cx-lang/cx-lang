NODE_MODULES = ${CURDIR}/node_modules
SDK_DIR      = ${CURDIR}/SDK
BIN_DIR      = $(NODE_MODULES)/.bin

COMMITHASH_FILE = .commithash
ESLINT_CONFIG   = $(SDK_DIR)/eslintrc.js

commithash:
	git rev-parse HEAD > $(COMMITHASH_FILE)

target-%: commithash
	@ node $(SDK_DIR)/bundle $@

lint:
	$(BIN_DIR)/eslint -c $(ESLINT_CONFIG) SDK Source

test:
	node $(SDK_DIR)/specRunner

clean:
	$(BIN_DIR)/rimraf $(COMMITHASH_FILE) *.js

.PHONY:  commithash lint test clean
.SILENT: commithash lint test clean
