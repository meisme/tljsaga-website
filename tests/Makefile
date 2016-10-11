# Project: TLJSaga tests
#
# File: Makefile
# Use:  Build the tests
# Version: 2016.10.11
#
# Copyright © 2016 Kristian Høy Horsberg
# Available under version 3 of GNU Affero General Public License
#
# Author: Kristian Høy Horsberg <khh1990@gmail.com>
#

SHELL = /bin/sh

NAME = tljsaga-website-tests

LIBS = -lcppcms -lbooster
CXXFLAGS = -g -Wall -pedantic -std=c++11
LDLIBS = $(LIBS)

GCOVR = gcovr
GCOVRFLAGS = --xml-pretty -r

SRCDIR = src
OBJDIR = obj
COV_OBJDIR = covtests
COV_MAINOBJDIR = covmain
BINDIR = bin
WIN32DIR= win32
MAINSRC = ../src
MAINOBJ = ../obj
MAINFILE = $(MAINSRC)/website.cpp
TESTFILE = $(SRCDIR)/tests.cpp

TARGET = $(BINDIR)/$(NAME)
COVERAGETARGET = $(TARGET)-coverage
CATCH = $(SRCDIR)/catch.hpp
RUN = ./
RUNCMD = $(shell printf '$(RUN)'; test '$(RUN)' != './' && printf ' ' || : )
REPORT := $(shell test ! -z '$(REPORT)' && printf '$(REPORT)' || printf 'report.xml' )

rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

SOURCES  := $(call rwildcard,$(SRCDIR)/,*.cpp)
COV_SOURCES := $(filter-out $(TESTFILE),$(SOURCES))
MAIN_SOURCES := $(call rwildcard,$(MAINSRC),*.cpp)
MAIN_SOURCES := $(filter-out $(MAINFILE),$(MAIN_SOURCES))

OBJECTS := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)
MAIN_OBJECTS := $(MAIN_SOURCES:$(MAINSRC)/%.cpp=$(MAINOBJ)/%.o)
COV_OBJECTS := $(COV_SOURCES:$(SRCDIR)/%.cpp=$(COV_OBJDIR)/%.o)
COV_MAINOBJECTS := $(MAIN_SOURCES:$(MAINSRC)/%.cpp=$(COV_MAINOBJDIR)/%.o)

TESTOBJECT = $(TESTFILE:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

DEPDIR := .d
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td

COVFLAGS = -fprofile-arcs -ftest-coverage -fPIC -O0 -g

COMPILE.cpp = $(CXX) $(DEPFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
COVERAGE.COMPILE.cpp = $(COMPILE.cpp) $(COVFLAGS)
LINK = $(CXX) $(LDFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH)
COVERAGE.LINK = $(LINK) $(COVFLAGS) -lgcov
POSTCOMPILE = mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d

.PHONY: all warning setup clean distclean run maintainer-clean win32-clean test coverage
.SUFFIXES:

all: setup $(TARGET) $(COVERAGETARGET)

$(DEPDIR):
	@mkdir -p "$@"

$(OBJDIR):
	@mkdir -p "$@"

$(BINDIR):
	@mkdir -p "$@"

$(COV_OBJDIR):
	@mkdir -p "$@"

$(COV_MAINOBJDIR):
	@mkdir -p "$@"

warning:
	@test -z "$(MAKEFLAGS)" && \
	env echo -e '\e[1;31mThis file is not designed to be invoked directly. Run "make test" or "make coverage" in the parent directory\e[0m' && false || :

setup: warning $(OBJDIR) $(BINDIR) $(DEPDIR) $(COV_OBJDIR) $(COV_MAINOBJDIR) $(CATCH)

$(CATCH):
	wget https://raw.githubusercontent.com/philsquared/Catch/master/single_include/catch.hpp -O $@ || rm -f $(CATCH)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp $(DEPDIR)/%.d
	@test -d "$(@D)" || mkdir -p "$(@D)"
	@test -d "$(patsubst $(OBJDIR)/%,$(DEPDIR)/%,$(@D))" || mkdir -p "$(patsubst $(OBJDIR)/%,$(DEPDIR)/%,$(@D))"
	@echo COMPILE.cpp $< -o $@
	@$(COMPILE.cpp) -c $< -o $@
	@$(POSTCOMPILE)

$(COV_OBJDIR)/%.o: $(SRCDIR)/%.cpp $(DEPDIR)/%.d
	@test -d "$(@D)" || mkdir -p "$(@D)"
	@test -d "$(patsubst $(COV_OBJDIR)/%,$(DEPDIR)/%,$(@D))" || mkdir -p "$(patsubst $(COV_OBJDIR)/%,$(DEPDIR)/%,$(@D))"
	@echo COVERAGE.COMPILE.cpp $< -o $@
	@$(COVERAGE.COMPILE.cpp) -c $< -o $@
	@$(POSTCOMPILE)

$(COV_MAINOBJDIR)/%.o: $(MAINSRC)/%.cpp $(DEPDIR)/%.d
	@test -d "$(@D)" || mkdir -p "$(@D)"
	@test -d "$(patsubst $(COV_MAINOBJDIR)/%,$(DEPDIR)/%,$(@D))" || mkdir -p "$(patsubst $(COV_MAINOBJDIR)/%,$(DEPDIR)/%,$(@D))"
	@echo COVERAGE.COMPILE.cpp $< -o $@
	@$(COVERAGE.COMPILE.cpp) -c $< -o $@
	@$(POSTCOMPILE)

$(TARGET): $(MAIN_OBJECTS) $(OBJECTS)
	@echo LINK $^ -o $@ $(LDLIBS)
	@$(LINK) $^ -o $@ $(LDLIBS)

$(COVERAGETARGET): $(COV_MAINOBJECTS) $(COV_OBJECTS) $(TESTOBJECT)
	@echo COVERAGE.LINK $^ -o $@ $(LDLIBS)
	@$(COVERAGE.LINK) $^ -o $@ $(LDLIBS)

clean:
	@test -d "$(OBJDIR)" && find "$(OBJDIR)" -name \*.o | xargs rm -vf || :
	@test -d "$(COV_OBJDIR)" && find "$(COV_OBJDIR)" -name \*.o | xargs rm -vf || :
	@test -d "$(COV_OBJDIR)" && find "$(COV_OBJDIR)" -name \*.gcda | xargs rm -vf || :
	@test -d "$(COV_OBJDIR)" && find "$(COV_OBJDIR)" -name \*.gcno | xargs rm -vf || :
	@test -d "$(COV_MAINOBJDIR)" && find "$(COV_MAINOBJDIR)" -name \*.o | xargs rm -vf || :
	@test -d "$(COV_MAINOBJDIR)" && find "$(COV_MAINOBJDIR)" -name \*.gcda | xargs rm -vf || :
	@test -d "$(COV_MAINOBJDIR)" && find "$(COV_MAINOBJDIR)" -name \*.gcno | xargs rm -vf || :
	@find -name \*.Td | xargs rm -fv
	@rm -fv $(TARGET)
	@rm -fv $(COVERAGETARGET)
	@rm -fv $(REPORT)

win32-clean:
	@rm -fv $(WIN32DIR)/*.VC.db
	@rm -rfv $(WIN32DIR)/Debug
	@rm -rfv $(WIN32DIR)/Release
	@rm -rfv $(WIN32DIR)/ipch
	@rm -rfv $(WIN32DIR)/packages

distclean: win32-clean
	@test -d "$(OBJDIR)" && find "$(OBJDIR)" -type d | tac | xargs rmdir -v || :
	@test -d "$(BINDIR)" && find "$(BINDIR)" -type d | tac | xargs rmdir -v || :
	@test -d "$(DEPDIR)" && find "$(DEPDIR)" -name *.d -type f | xargs rm -fv || :
	@test -d "$(DEPDIR)" && find "$(DEPDIR)" -type d | tac | xargs rmdir -v || :
	@test -d "$(COV_OBJDIR)" && find "$(COV_OBJDIR)" -type d | tac | xargs rmdir -v || :
	@test -d "$(COV_MAINOBJDIR)" && find "$(COV_MAINOBJDIR)" -type d | tac | xargs rmdir -v || :

maintainer-clean:
	@rm -fv $(CATCH)

$(DEPDIR)/%.d: ;

.PRECIOUS: $(TARGET) $(COVERAGETARGET) $(OBJECTS) $(COV_OBJECTS) $(COV_MAINOBJECTS) $(DEPDIR)/%.d

-include $(patsubst $(SRCDIR)%.cpp,$(DEPDIR)%.d,$(SOURCES))

test: setup $(TARGET)
	$(RUNCMD)$(TARGET) $(TESTOPTIONS)

coverage: setup $(COVERAGETARGET)
	$(RUNCMD)$(COVERAGETARGET) $(TESTOPTIONS)
	$(GCOVR) $(GCOVRFLAGS) . > $(REPORT)
