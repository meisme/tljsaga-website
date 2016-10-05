# Project: TLJSaga
#
# File: Makefile
# Use:  Build the application
# Version: 0.0.0 Alpha
#
# Copyright © 2016 Kristian Høy Horsberg
# All Rights Reserved
#
# Author: Kristian Høy Horsberg <khh1990@gmail.com>
#

SHELL = /bin/sh

NAME = tljsaga-website

LIBS = -lcppcms -lbooster
CXXFLAGS = -g -Wall -std=c++11
LDFLAGS = -L/usr/local/lib/
LDLIBS = $(LIBS)

SRCDIR = src
OBJDIR = obj
BINDIR = bin
TESTDIR = tests
TMPLDIR = src/templates
DATAHEADERDIR = src/data

TARGET = $(BINDIR)/$(NAME)
PRECOMPILED_HEADER = $(SRCDIR)/website.h
RUN = ./
RUNCMD = $(shell printf '$(RUN)'; test '$(RUN)' != './' && printf ' ' || : )
CONFIG = res/config.js

rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

TEMPLATES:= $(call rwildcard,$(TMPLDIR)/,*.tmpl)
TEMPLATE_SOURCE := $(SRCDIR)/templates.tmpl-cpp
TEMPLATE_OBJECT := $(TEMPLATE_SOURCE:$(SRCDIR)/%.tmpl-cpp=$(OBJDIR)/%.o)
CPP_SOURCES  := $(call rwildcard,$(SRCDIR)/,*.cpp)
C_SOURCES  := $(call rwildcard,$(SRCDIR)/,*.c)
SOURCES := $(CPP_SOURCES) $(C_SOURCES)
DATA_HEADERS := $(call rwildcard,$(DATAHEADERDIR)/,*.h)
OBJECTS := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

DEPDIR := .d
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td

COMPILE.c = $(CC) $(DEPFLAGS) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
COMPILE.cpp = $(CXX) $(DEPFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
COMPILE.gch = $(CXX) -MT $@ -MMD -MP -MF $(patsubst $(SRCDIR)%,$(DEPDIR)%,$@).Td $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
COMPILE.tmpl-cpp = $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -x c++
LINK = $(CXX) $(LDFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
POSTCOMPILE = mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d
POSTCOMPILE.gch = mv -f $(patsubst $(SRCDIR)%,$(DEPDIR)%,$@).Td $(patsubst $(SRCDIR)%,$(DEPDIR)%,$@).d

.PHONY: all setup clean distclean dist deploy test run


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

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(DEPDIR)/%.d
	@test -d "$(@D)" || mkdir -p "$(@D)"
	@test -d "$(patsubst $(OBJDIR)/%,$(DEPDIR)/%,$(@D))" || mkdir -p "$(patsubst $(OBJDIR)/%,$(DEPDIR)/%,$(@D))"
	@echo COMPILE.c $< -o $@
	@$(COMPILE.c) -c $< -o $@
	@$(POSTCOMPILE)

$(PRECOMPILED_HEADER).gch: $(PRECOMPILED_HEADER)
	@test -d "$(@D)" || mkdir -p "$(@D)"
	@test -d "$(patsubst $(SRCDIR)/%,$(DEPDIR)/%,$(@D))" || mkdir -p "$(patsubst $(SRCDIR)/%,$(DEPDIR)/%,$(@D))"
	@echo COMPILE.gch $< -o $@
	@$(COMPILE.gch) $< -o $@
	@$(POSTCOMPILE.gch)

$(TEMPLATE_SOURCE): $(TEMPLATES)
	cppcms_tmpl_cc $^ -o $@

$(TEMPLATE_OBJECT): $(OBJECT_DIR) $(TEMPLATE_SOURCE) $(DATA_HEADERS)
	@echo COMPILE.tmpl-cpp $< -o $@
	@$(COMPILE.tmpl-cpp) -c $< -o $@

$(TARGET): $(OBJECTS) $(TEMPLATE_OBJECT)
	@echo LINK $(OBJECTS) $(TEMPLATE_OBJECT) -o $@ $(LOADLIBES) $(LDLIBS)
	@$(LINK) $(OBJECTS) $(TEMPLATE_OBJECT) -o $@ $(LOADLIBES) $(LDLIBS)

clean:
	test -d "$(OBJDIR)" && find "$(OBJDIR)" -name *.o | xargs rm -f || :
	find -name *.Td | xargs rm -f
	find -name *.tmpl-cpp | xargs rm -f
	rm -f $(TARGET)
	@cd "$(TESTDIR)" && $(MAKE) clean

distclean: clean
	test -d "$(OBJDIR)" && find "$(OBJDIR)" -type d | tac | xargs rmdir || :
	test -d "$(BINDIR)" && find "$(BINDIR)" -type d | tac | xargs rmdir || :
	test -d "$(DEPDIR)" && find "$(DEPDIR)" -name *.d -type f | xargs rm -f || :
	test -d "$(DEPDIR)" && find "$(DEPDIR)" -type d | tac | xargs rmdir || :
	test -e "$(PRECOMPILED_HEADER).gch" && rm "$(PRECOMPILED_HEADER).gch" || :
	@cd "$(TESTDIR)" && $(MAKE) distclean

run: all
	$(RUNCMD)$(TARGET) -c $(CONFIG)

dist:
	@echo "TODO: Distrobution"

deploy:
	@echo "TODO: Deploy"

test: setup $(OBJECTS)
	@cd "$(TESTDIR)" && $(MAKE) run


$(DEPDIR)/%.d: ;

.PRECIOUS: $(TARGET) $(OBJECTS) $(CXXOBJECTS) $(DEPDIR)/%.d

-include $(patsubst $(SRCDIR)%.cpp,$(DEPDIR)%.d,$(CPP_SOURCES))
-include $(patsubst $(SRCDIR)%.c,$(DEPDIR)%.d,$(C_SOURCES))
-include $(patsubst $(SRCDIR)%,$(DEPDIR)%.d,$(PRECOMPILED_HEADER))

# Everything below is cruft for GNU compliance
.PHONY: install install-html install-dvi install-pfd install-ps install-strip\
	mostlyclean maintainer-clean uninstall TAGS info dvi html pdf ps check

install:
	@echo "Application is not installable" 1>&2

install-html: install
install-dvi: install
install-pfd: install
install-ps: install
install-strip: install

mostlyclean: clean

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
