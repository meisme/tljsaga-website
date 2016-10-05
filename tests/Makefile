# Project: TLJSaga tests
#
# File: Makefile
# Use:  Build the tests
# Version: 2016.10.05
#
# Copyright © 2016 Kristian Høy Horsberg
# Available under version 3 of GNU Affero General Public License
#
# Author: Kristian Høy Horsberg <khh1990@gmail.com>
#

SHELL = /bin/sh

NAME = tljsaga-website-tests

CXXFLAGS = -g -Wall -std=c++11
LDFLAGS = -L/usr/local/lib/
LDLIBS = $(LIBS) -lcppcms -lbooster

SRCDIR = src
OBJDIR = obj
BINDIR = bin
MAINSRC = ../src
MAINOBJ = ../obj
MAINFILE = $(MAINSRC)/website.cpp

TARGET = $(BINDIR)/$(NAME)
CATCH = $(SRCDIR)/catch.hpp
RUN = ./
RUNCMD = $(shell printf '$(RUN)'; test '$(RUN)' != './' && printf ' ' || : )
CONFIG = res/config.js

rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

TEST_SOURCES := $(call rwildcard,$(MAINSRC),*.cpp)
TEST_SOURCES := $(filter-out $(MAINFILE),$(TEST_SOURCES))
CPP_SOURCES  := $(call rwildcard,$(SRCDIR)/,*.cpp)
SOURCES := $(CPP_SOURCES) $(C_SOURCES) $(TEST_SOURCES)
OBJECTS := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)
OBJECTS := $(OBJECTS:$(MAINSRC)/%.cpp=$(MAINOBJ)/%.o)

DEPDIR := .d
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td

COMPILE.c = $(CC) $(DEPFLAGS) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
COMPILE.cpp = $(CXX) $(DEPFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
LINK = $(CXX) $(LDFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
POSTCOMPILE = mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d

.PHONY: all setup clean distclean run maintainer-clean test check


all: setup $(TARGET)

$(DEPDIR):
	@mkdir -p "$@"

$(OBJDIR):
	@mkdir -p "$@"

$(BINDIR):
	@mkdir -p "$@"

setup: $(OBJDIR) $(BINDIR) $(DEPDIR)
	@test -z "$(MAKEFLAGS)" && /bin/echo -e '\e[1;31mThis file is not designed to be invoked directly. Run "make test" in the parent directory\e[0m' && false || :

$(CATCH):
	wget https://raw.githubusercontent.com/philsquared/Catch/master/single_include/catch.hpp -O $@ || rm -f $(CATCH)

$(OBJDIR)/%.o : $(SRCDIR)/%.cpp $(DEPDIR)/%.d
	@test -d "$(@D)" || mkdir -p "$(@D)"
	@test -d "$(patsubst $(OBJDIR)/%,$(DEPDIR)/%,$(@D))" || mkdir -p "$(patsubst $(OBJDIR)/%,$(DEPDIR)/%,$(@D))"
	@echo COMPILE.cpp $< -o $@
	@$(COMPILE.cpp) -c $< -o $@
	@$(POSTCOMPILE)

$(OBJDIR)/%.o : $(SRCDIR)/%.c $(DEPDIR)/%.d
	@test -d "$(@D)" || mkdir -p "$(@D)"
	@test -d "$(patsubst $(OBJDIR)/%,$(DEPDIR)/%,$(@D))" || mkdir -p "$(patsubst $(OBJDIR)/%,$(DEPDIR)/%,$(@D))"
	@echo COMPILE.c $< -o $@
	@$(COMPILE.c) -c $< -o $@
	@$(POSTCOMPILE)

$(TARGET): $(CATCH) $(OBJECTS) $(TEMPLATE_OBJECT)
	@echo LINK $(OBJECTS) $(TEMPLATE_OBJECT) -o $@ $(LOADLIBES) $(LDLIBS)
	@$(LINK) $(OBJECTS) $(TEMPLATE_OBJECT) -o $@ $(LOADLIBES) $(LDLIBS)

clean:
	test -d "$(OBJDIR)" && find "$(OBJDIR)" -name *.o | xargs rm -f || :
	find -name *.Td | xargs rm -f
	find -name *.tmpl-cpp | xargs rm -f
	rm -f $(TARGET)

distclean:
	test -d "$(OBJDIR)" && find "$(OBJDIR)" -type d | tac | xargs rmdir || :
	test -d "$(BINDIR)" && find "$(BINDIR)" -type d | tac | xargs rmdir || :
	test -d "$(DEPDIR)" && find "$(DEPDIR)" -name *.d -type f | xargs rm -f || :
	test -d "$(DEPDIR)" && find "$(DEPDIR)" -type d | tac | xargs rmdir || :
	test -e "$(PRECOMPILED_HEADER).gch" && rm "$(PRECOMPILED_HEADER).gch" || :

run: all
	$(RUNCMD)$(TARGET)


$(DEPDIR)/%.d: ;

.PRECIOUS: $(TARGET) $(OBJECTS) $(CXXOBJECTS) $(DEPDIR)/%.d

-include $(patsubst $(SRCDIR)%.cpp,$(DEPDIR)%.d,$(CPP_SOURCES))
-include $(patsubst $(SRCDIR)%.c,$(DEPDIR)%.d,$(C_SOURCES))
-include $(patsubst $(SRCDIR)%,$(DEPDIR)%.d,$(PRECOMPILED_HEADER))

maintainer-clean:
	rm -f $(CATCH)

test: run
check: test
