status:
	git status -s

ungit:
	ungit --urlBase http://$IP --port $PORT

build:
	node build all

lib:
	node build lib

dist:
	node build dist

std:
	node build std

docs:
	node build docs

test:
	node test all

benchmark:
	node test benchmark

lint:
	node test lint

spec:
	node test spec

clean:
	rm -rf dist
	rm -rf docs
	rm -rf test/*/results

.PHONY:  status ungit build lib dist std docs test benchmark lint spec clean
.SILENT: status ungit build lib dist std docs test benchmark lint spec clean
