NPM_PATH=$(shell npm bin)
LUABUNDLER?="$(NPM_PATH)/luabundler"
BUNDLE_OPTS:=--isolate -l 5.1 -p  "src/?.lua"
SRC=mission.lua
MIZ_FILE=conquest_persian_gulf.miz

build: clean compile $(MIZ_FILE)

compile: out/conquest_persian_gulf.lua

$(MIZ_FILE): unpack out/conquest_persian_gulf.lua pack

out/conquest_persian_gulf.lua: $(SRC)
	$(LUABUNDLER) bundle $< $(BUNDLE_OPTS) -o $@

clean:
	rm -rf out/*

pack:
	cp out/conquest_persian_gulf.lua out/unpacked/l10n/DEFAULT
	cd out/unpacked && 7z a -r -y -tzip ../../$(MIZ_FILE) *

unpack:
	mkdir -p out/unpacked
	cd out/unpacked && 7z x -r -y -tzip ../../$(MIZ_FILE) *

.PHONY: clean build all unpack compile