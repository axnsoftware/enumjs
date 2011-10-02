#
# Copyright 2011 axn software UG (haftungsbeschränkt)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PROJECT = enumjs

INSTALL_ROOT = /usr/local/share/node_modules

SRC = src/lib/enumjs.coffee
TESTSRC = src/test/basic.coffee

LIB = build/lib/enumjs.js
TEST = build/test/basic.js

GIT_BIN = `which git`
EYES_LIB = ./node_modules/eyes/lib/eyes.js
VOWS_BIN = ./node_modules/vows/bin/vows
COFFEE_BIN = ./node_modules/coffee-script/bin/coffee
NODE_BIN = `which node`
NODE_VER = `$$(which node) --version`


.PHONY: test install uninstall prerequisites clean clean-modules

all: prerequisites $(LIB) $(TEST) test

clean-modules: 
	@-rm -rf node_modules/eyes
	@-rm -rf node_modules/vows
	@-rm -rf node_modules/jsmockito
	@-rm -rf node_modules/coffee-script

clean:
	@-rm -Rf build
	@-rm -f ./install.log

$(LIB): $(SRC)
	$(COFFEE_BIN) -o build/lib/ -c $?

$(TEST): $(TESTSRC)
	$(COFFEE_BIN) -o build/test/ -c $?

prerequisites:
	@echo "Checking prerequisites..."
	@echo -n "-> checking availability of node..." \
		&& ( test -f "$(NODE_BIN)" && echo "FOUND. (Path: $(NODE_BIN); Version: $(NODE_VER).)" ) \
		|| ( echo; echo "-> ERR node is not available. Install node version 0.5.x or greater first."; exit 1);
	@echo -n "-> checking console.dir()..." \
		&& ( $(NODE_BIN) >/dev/null -e "var t = function() {}; t.f = function() { throw new Error(); }; console.dir(t);" && echo "OK." ) \
		|| ( echo; echo "-> ERR console.dir() is broken. Use node version 0.5.x or greater. (Version: ${NODE_VER}.)"; exit 1 );
	@echo "-> initializing submodules in ./node_modules" \
		&& $(GIT_BIN) submodule init \
		|| ( echo "-> ERR unable to initialize submodules."; exit 1 );
	@echo "-> updating submodules in ./node_modules" \
		&& $(GIT_BIN) submodule update \
		|| ( echo "-> ERR unable to update submodules."; exit 1 );
	@echo "-> synchronizing submodules in ./node_modules" \
		&& $(GIT_BIN) submodule sync \
		|| ( echo "-> ERR unable to synchronize submodules."; exit 1 );
	@echo -n "-> checking availability of ./node_modules/vows..." \
		&& ( test -f $(VOWS_BIN) && echo "FOUND." ) \
		|| ( echo; echo "-> ERR ./node_modules/vows is not available."; exit 1);
	@echo -n "-> checking whether $(VOWS_BIN) is executable..." \
		&& ( test -x $(VOWS_BIN) && echo "OK." ) \
		|| ( echo; echo "-> ERR $(VOWS_BIN) is not executable."; exit 1);
	@echo -n "-> checking availability of ./node_modules/eyes..." \
		&& ( test -f $(EYES_LIB) && echo "FOUND." ) \
		|| ( echo; echo "-> ERR ./node_modules/eyes is not available."; exit 1);
	@@-mkdir -p build/lib build/test

test: $(TEST)
	@echo "Running tests..."
	@-$(VOWS_BIN) --xunit $? > $?.xml
	$(VOWS_BIN) $?

install: all
	@echo "Installing..."
	@:>install.log
	@( \
		echo "Installing..."; \
		install -v -d -m 655 $(INSTALL_ROOT) \
		&& install -v -d -m 655 $(INSTALL_ROOT)/enumjs \
		&& install -v -d -m 655 $(INSTALL_ROOT)/enumjs/lib \
		&& install -v -m 644 -t $(INSTALL_ROOT)/enumjs/ package.json \
		&& install -v -m 644 -t $(INSTALL_ROOT)/enumjs/ README \
		&& install -v -m 644 -t $(INSTALL_ROOT)/enumjs/ LICENSE \
		&& install -v -m 644 -t $(INSTALL_ROOT)/enumjs/lib/ build/lib/enumjs.js \
	) 2>>install.log >>install.log \
	|| ( \
		echo "Installation failed. Rolling back the operation..."; \
                ( \
			echo "Installation failed. Rolling back the operation..."; \
			( test -f $(INSTALL_ROOT)/enumjs/lib/enumjs.js && rm -f $(INSTALL_ROOT)/enumjs/lib/enumjs.js ) \
			&& ( test -f $(INSTALL_ROOT)/enumjs/README && rm -f $(INSTALL_ROOT)/enumjs/README ) \
			&& ( test -f $(INSTALL_ROOT)/enumjs/LICENSE && rm -f $(INSTALL_ROOT)/enumjs/LICENSE ) \
			&& ( test -f $(INSTALL_ROOT)/enumjs/package.json && rm -f $(INSTALL_ROOT)/enumjs/package.json ) \
			&& ( test -d $(INSTALL_ROOT)/enumjs/lib/ && rmdir $(INSTALL_ROOT)/enumjs/lib/ ) \
			&& ( test -d $(INSTALL_ROOT)/enumjs/ && rmdir $(INSTALL_ROOT)/enumjs/ ) \
                        && ( test -d $(INSTALL_ROOT)/ && rmdir $(INSTALL_ROOT)/ ) \
			&& echo "Successfully removed partly installed package." \
                ) 2>>install.log >>install.log \
		|| ( echo "Removal of package or artifacts thereof failed. See install.log for more information."; exit 1 ); \
		echo "Successfully removed partly installed package." \
	)
	@echo "Installation was successful. See install.log for more information."

uninstall:
	@echo "Uninstalling..."
	@( \
		echo "Uninstalling..."; \
		( test -f $(INSTALL_ROOT)/enumjs/lib/enumjs.js && rm -f $(INSTALL_ROOT)/enumjs/lib/enumjs.js ) \
		&& ( test -f $(INSTALL_ROOT)/enumjs/README && rm -f $(INSTALL_ROOT)/enumjs/README ) \
		&& ( test -f $(INSTALL_ROOT)/enumjs/LICENSE && rm -f $(INSTALL_ROOT)/enumjs/LICENSE ) \
		&& ( test -f $(INSTALL_ROOT)/enumjs/package.json && rm -f $(INSTALL_ROOT)/enumjs/package.json ) \
		&& ( test -d $(INSTALL_ROOT)/enumjs/lib/ && rmdir $(INSTALL_ROOT)/enumjs/lib/ ) \
		&& ( test -d $(INSTALL_ROOT)/enumjs/ && rmdir $(INSTALL_ROOT)/enumjs/ ) \
		&& ( test -d $(INSTALL_ROOT)/ && rmdir $(INSTALL_ROOT)/ ) \
		&& echo "Successfully removed installed package." \
	) 2>>install.log >>install.log \
	|| ( echo "Removal of package or artifacts thereof failed. See install.log for more information."; exit 1 );
	@echo "Successfully removed installed package."

