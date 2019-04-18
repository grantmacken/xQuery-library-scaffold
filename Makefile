SHELL=/bin/bash

ifeq ("","$(wildcard ./VERSION)")
    $(shell touch VERSION && echo 'v0.0.0' > VERSION)
endif

LAST_TAG_COMMIT = $(shell git rev-list --tags --max-count=1)
LAST_TAG = $(shell git describe --tags $(LAST_TAG_COMMIT) )
TAG_PREFIX = "v"

VERSION != grep -oP '^v\K(.+)$$' VERSION
include .env

git_user != git config user.name
nsname=http://$(NS_DOMAIN)/\#$(NAME)
title != echo $(TITLE)
include inc/repo.mk inc/expath-pkg.mk

.PHONY: default
default: clean compile-main build

build: deploy/$(NAME).xar
	@echo '##[ $@ ]##'
	@bin/xQdeploy $<
	@bin/semVer $(VERSION) patch > VERSION
	@#touch unit-tests/t-$(NAME).xqm
	@echo -n 'INFO: prepped for next build: ' && cat VERSION

.PHONY: test
test: compile-test
	@prove -v bin/xQtest

.PHONY: clean
clean:
	@rm -rfv tmp &>/dev/null
	@rm -rfv build &>/dev/null
	@rm -rfv deploy &>/dev/null

.PHONY: up
up: | clean
	@echo -e '##[ $@ ]##'
	@bin/exStartUp
	@touch VERSION && echo 'v0.0.1' > VERSION

.PHONY: down
down:
	@echo -e '##[ $@ ]##'
	@docker-compose down

.PHONY: compile-main
compile-main: content/${NAME}.xqm
	@echo '##[ $@  $< ]##'
	@mkdir -p tmp
	@bin/xQcompile $<

.PHONY: compile-test
compile-test: unit-tests/t-${NAME}.xqm
	@#' that will not compile unless ${NAME}.xqm is deployed '
	@echo '##[ $@  $< ]##'
	@mkdir -p tmp
	@bin/xQcompile $< | grep -oP '^INFO:(.+)OK!$$' \
 || ( bin/xQcompile $< ; false )

build/repo.xml: export repoXML:=$(repoXML)
build/repo.xml:
	@echo '##[ $@ ]##'
	@echo "$${repoXML}"
	@mkdir -p $(dir $@)
	@echo "$${repoXML}" > $@

build/expath-pkg.xml: export expathPkgXML:=$(expathPkgXML)
build/expath-pkg.xml:
	@echo '##[ $@ ]##'
	@echo "$${expathPkgXML}" 
	@mkdir -p $(dir $@)
	@echo "$${expathPkgXML}" > $@

build/content/$(NAME).xqm: content/$(NAME).xqm
	@echo '##[ $@ ]##'
	@mkdir -p $(dir $@)
	@cp $< $@

deploy/$(NAME).xar: \
 build/repo.xml \
 build/expath-pkg.xml \
 build/content/$(NAME).xqm
	@echo '##[ $@ ]## '
	@mkdir -p $(dir $@)
	@cd build && zip $(abspath $@) -r .

.PHONY: prep-release
prep-release:
	@echo '##[ $@ ]##'
	@#echo ' - working VERSION: $(VERSION) ' 
	@echo ' -        last tag: $(LAST_TAG)' 
	@if [ -z '$(LAST_TAG)' ] ; \
 then echo 'v0.0.0' > VERSION ; \
 else echo '$(LAST_TAG)' > VERSION ; fi 
	@bin/semVer $(VERSION) patch > VERSION
	@echo -n ' -  bumped VERSION: ' 
	@cat VERSION
	@echo ' - do a build from the current tag' 
	@$(MAKE) --silent &>/dev/null
	@echo -n ' - expath-pkg version: ' 
	@echo $$(grep -oP 'version="\K((\d+\.){2}\d+)' build/expath-pkg.xml)
	echo $(shell grep -oP 'version="\K((\d+\.){2}\d+)' build/expath-pkg.xml)

.PHONY: release
push-release:
	@git tag v$(shell grep -oP 'version="\K((\d+\.){2}\d+)' build/expath-pkg.xml)
	@git push origin  v$(shell grep -oP 'version="\K((\d+\.){2}\d+)' build/expath-pkg.xml)

.PHONY: log
log:
	@docker logs -f --since 1m $(CONTAINER)

.PHONY: travis-enable
travis-enable:
	@echo '##[ $@ ]##'
	@travis enable

# https://docs.travis-ci.com/user/deployment/releases
.PHONY: travis-setup-releases
travis-setup-releases:
	@echo '##[ $@ ]##'
	@travis setup releases

.PHONY: gitLog
gitLog:
	@clear
	@git --no-pager log \
  -n 10\
 --pretty=format:'%Cred%h%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'

.PHONY: smoke
smoke: 
	@echo '##[ $@ ]##'
	@bin/xQcall '$(NAME):example("$(git_user)")' \
 | grep -oP '^(\w+)$$'

.PHONY: coverage
coverage: 
	@echo '##[ $@ ]##'
	@bin/xQcall 'system:clear-trace()'  &>/dev/null
	@bin/xQcall 'system:enable-tracing(true())'  &>/dev/null
	@bin/xQcall '$(NAME):example()' &>/dev/null
	@bin/xQcall 'system:enable-tracing(false())' &>/dev/null
	@bin/xQtrace

.PHONY: guide
guide: 
	@echo '##[ $@ ]##'
	@bin/xQguide


PHONY: init-repo
init-repo:
	@git init
	@git add .
	@git commit -m "first commit"
	@git remote add origin git@github.com:$(git_user)/$(NAME).git
	@git push origin master


