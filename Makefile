COMMITHASH_FILE = .commithash

commithash:
	git rev-parse HEAD > $(COMMITHASH_FILE)

target/%: commithash
	@ node SDK/bundler $(subst target/,TARGET:,$@)

clean:
	${CURDIR}/node_modules/.bin/rimraf $(COMMITHASH_FILE) *.js

.PHONY:  commithash clean
.SILENT: commithash clean
