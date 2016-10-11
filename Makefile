# Project: TLJSaga
#
# File: Makefile
# Use:  Build the application
# Version: 2016.10.11
#
# Copyright © 2016 Kristian Høy Horsberg
# Available under version 3 of GNU Affero General Public License
#
# Author: Kristian Høy Horsberg <khh1990@gmail.com>
#

SHELL = /bin/sh

NAME = tljsaga-website

LIBS = -lcppcms -lbooster
CXXFLAGS = -g -Wall -pedantic -std=c++11
LDLIBS = $(LIBS)

SRCDIR = src
OBJDIR = obj
BINDIR = bin
TESTDIR = tests
TMPLDIR = src/templates
DATAHEADERDIR = src/data
WIN32DIR= win32

TARGET = $(BINDIR)/$(NAME)
PRECOMPILED_HEADER = $(SRCDIR)/website.h
RUN = ./
RUNCMD = $(shell printf '$(RUN)'; test '$(RUN)' != './' && printf ' ' || : )
CONFIG = res/config.js

rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

TEMPLATES:= $(call rwildcard,$(TMPLDIR)/,*.tmpl)
TEMPLATE_SOURCE := $(SRCDIR)/templates.tmpl-cpp
TEMPLATE_OBJECT := $(TEMPLATE_SOURCE:$(SRCDIR)/%.tmpl-cpp=$(OBJDIR)/%.o)
SOURCES := $(call rwildcard,$(SRCDIR)/,*.cpp)
DATA_HEADERS := $(call rwildcard,$(DATAHEADERDIR)/,*.h)
OBJECTS := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

DEPDIR := .d
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td

COMPILE.cpp = $(CXX) $(DEPFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
COMPILE.gch = $(CXX) -MT $@ -MMD -MP -MF $(patsubst $(SRCDIR)%,$(DEPDIR)%,$@).Td $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
COMPILE.tmpl-cpp = $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -x c++
LINK = $(CXX) $(LDFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
POSTCOMPILE = mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d
POSTCOMPILE.gch = mv -f $(patsubst $(SRCDIR)%,$(DEPDIR)%,$@).Td $(patsubst $(SRCDIR)%,$(DEPDIR)%,$@).d

.PHONY: all setup clean distclean maintainer-clean win32-clean dist deploy test run coverage


all: setup $(TARGET)

$(DEPDIR):
	@mkdir -p "$@"

$(OBJDIR):
	@mkdir -p "$@"

$(BINDIR):
	@mkdir -p "$@"

setup: $(OBJDIR) $(BINDIR) $(DEPDIR)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp $(DEPDIR)/%.d $(PRECOMPILED_HEADER).gch
	@test -d "$(@D)" || mkdir -p "$(@D)"
	@test -d "$(patsubst $(OBJDIR)/%,$(DEPDIR)/%,$(@D))" || mkdir -p "$(patsubst $(OBJDIR)/%,$(DEPDIR)/%,$(@D))"
	@echo COMPILE.cpp $< -o $@
	@$(COMPILE.cpp) -c $< -o $@
	@$(POSTCOMPILE)

$(PRECOMPILED_HEADER).gch: $(PRECOMPILED_HEADER)
	@test -d "$(@D)" || mkdir -p "$(@D)"
	@test -d "$(patsubst $(SRCDIR)/%,$(DEPDIR)/%,$(@D))" || mkdir -p "$(patsubst $(SRCDIR)/%,$(DEPDIR)/%,$(@D))"
	@echo COMPILE.gch $< -o $@
	@$(COMPILE.gch) $< -o $@
	@$(POSTCOMPILE.gch)

$(TEMPLATE_SOURCE): $(TEMPLATES)
	cppcms_tmpl_cc $^ -o $@

$(TEMPLATE_OBJECT): $(TEMPLATE_SOURCE) $(DATA_HEADERS)
	@echo COMPILE.tmpl-cpp $< -o $@
	@$(COMPILE.tmpl-cpp) -c $< -o $@

$(TARGET): $(OBJECTS) $(TEMPLATE_OBJECT)
	@echo LINK $^ -o $@ $(LDLIBS)
	@$(LINK) $^ -o $@ $(LDLIBS)

clean:
	@test -d "$(OBJDIR)" && find "$(OBJDIR)" -name *.o | xargs rm -fv || :
	@find -name *.Td | xargs rm -fv
	@find -name *.tmpl-cpp | xargs rm -fv
	@rm -fv $(TARGET)
	@cd "$(TESTDIR)" && $(MAKE) clean

win32-clean:
	@rm -fv $(WIN32DIR)/*.VC.db
	@rm -rfv $(WIN32DIR)/Debug
	@rm -rfv $(WIN32DIR)/Release
	@rm -rfv $(WIN32DIR)/ipch
	@rm -rfv $(WIN32DIR)/packages
	@rm -rfv $(WIN32DIR)/.vs

distclean: clean win32-clean
	@test -d "$(OBJDIR)" && find "$(OBJDIR)" -type d | tac | xargs rmdir -v || :
	@test -d "$(BINDIR)" && find "$(BINDIR)" -type d | tac | xargs rmdir -v || :
	@test -d "$(DEPDIR)" && find "$(DEPDIR)" -name *.d -type f | xargs rm -fv || :
	@test -d "$(DEPDIR)" && find "$(DEPDIR)" -type d | tac | xargs rmdir -v || :
	@rm -fv "$(PRECOMPILED_HEADER).gch"
	@cd "$(TESTDIR)" && $(MAKE) distclean

maintainer-clean: distclean
	@echo -en '\n'
	@echo -e '\e[1;31mThis command is intended for maintainers to use; it'
	@echo -e 'deletes files that may need special tools to rebuild.\e[0m'
	@read -p "Continue? [y/N] " yn; \
		case $$yn in \
			y*|Y* ) printf 'Yes.\n\n' ; true ;;\
			* ) printf 'No.\n\n'; false ;;\
		esac
	@cd "$(TESTDIR)" && $(MAKE) maintainer-clean

run: all
	$(RUNCMD)$(TARGET) -c $(CONFIG)

dist:
	@echo "TODO: Distrobution"

deploy:
	@echo "TODO: Deploy"

test: setup $(OBJECTS)
	@cd "$(TESTDIR)" && $(MAKE) test

coverage:
	@cd "$(TESTDIR)" && $(MAKE) coverage

$(DEPDIR)/%.d: ;

.PRECIOUS: $(TARGET) $(OBJECTS) $(DEPDIR)/%.d

-include $(patsubst $(SRCDIR)%.cpp,$(DEPDIR)%.d,$(SOURCES))
-include $(patsubst $(SRCDIR)%,$(DEPDIR)%.d,$(PRECOMPILED_HEADER))

# Everything below is cruft for GNU compliance
.PHONY: install install-html install-dvi install-pfd install-ps install-strip\
	mostlyclean uninstall TAGS info dvi html pdf ps check

install:
	@echo "Application is not installable" 1>&2

install-html: install
install-dvi: install
install-pfd: install
install-ps: install
install-strip: install

mostlyclean: clean

uninstall:
	@echo "Application not installable - nothing to uninstall"

TAGS:
info:
	@echo "Proper documentation has yet to be written"  1>&2
dvi: info
html: info
pdf: info
ps: info

check: test
