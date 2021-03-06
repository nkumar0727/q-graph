#############################################################################
#		               quick-graphs Package Makefile	                    #
#############################################################################

#####################################################################
# INSTRUCTIONS
#####################################################################

# To build Google C++ Testing Framework 
# > make gtest
#
# To build quick-graph unit tests
# > make allTests
#
# To build quick-graph source object files and executables (post-testing) 
# > make allSrc 
#
# To clean quick-graph source object files and executables
# > make cleanSrc
#
# To clean Google C++ Testing Framework Build
# > make cleanTestBuild
#
# To clean both source object files/execuables and Google C++ Test Build
# > make clean
#

#################################################
# General 
#################################################

# User Source Code
USER_DIR = ./src

# User Object Files
USER_OBJ = $(USER_DIR)/obj

# Root of Google Test Source Files, relative to where this file is.
GTEST_DIR = $(HOME)/googletest/googletest

# Google Test Build location
GTEST_MAIN = ./gtest

# Tests produced by this makefile.
TESTS = $(USER_DIR)/adjMatrixTest $(USER_DIR)/graphTest

# Preprocessor Flags
CPPFLAGS += -isystem $(GTEST_DIR)/include

# C++ Compiler Flags
CXXFLAGS += -g -Wall -Wextra -pthread -std=c++11

#################################################
# Google C++ Testing Framework
#################################################

# All Google Test headers. DO NOT CHANGE.
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
				$(GTEST_DIR)/include/gtest/internal/*.h

# Google Test: gtest.a and gtest_main.a
GTEST_SRC_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

$(GTEST_MAIN)/gtest-all.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c $(GTEST_DIR)/src/gtest-all.cc -o $@

$(GTEST_MAIN)/gtest_main.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c $(GTEST_DIR)/src/gtest_main.cc -o $@

$(GTEST_MAIN)/gtest.a : $(GTEST_MAIN)/gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

$(GTEST_MAIN)/gtest_main.a : $(GTEST_MAIN)/gtest-all.o $(GTEST_MAIN)/gtest_main.o
	$(AR) $(ARFLAGS) $@ $^

#################################################
# Build and Housekeeping
#################################################

# Build Google C++ Testing Framework
gtest : $(GTEST_MAIN)/gtest.a $(GTEST_MAIN)/gtest_main.a

# Build all quick-graph unit tests
allTests : $(TESTS)

# Build quick-graph shell
shell : $(USER_DIR)/shell

# Clean object files and shell and test executables
cleanSrc :
	rm -f $(TESTS) $(USER_DIR)/shell $(USER_OBJ)/*.o

# Clean Google C++ Testing Build
cleanTestBuild : 
	rm -f $(GTEST_MAIN)/gtest.a $(GTEST_MAIN)/gtest_main.a \
		$(GTEST_MAIN)/*.o

# Clean object files and test executables, and Google C++ Testing Build
clean : cleanSrc cleanTestBuild

#################################################
# quick-graphs 
#################################################

$(USER_OBJ)/Graph.o : $(USER_DIR)/Graph.cpp $(USER_DIR)/Graph.h $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/Graph.cpp -o $@

$(USER_OBJ)/adjMatrixTest.o : $(GTEST_HEADERS) $(USER_DIR)/adjMatrixTest.cpp $(USER_DIR)/Graph.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/adjMatrixTest.cpp -o $@

$(USER_DIR)/adjMatrixTest : $(USER_OBJ)/Graph.o $(USER_OBJ)/adjMatrixTest.o $(GTEST_MAIN)/gtest.a 
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@

$(USER_OBJ)/graphTest.o : $(GTEST_HEADERS) $(USER_DIR)/graphTest.cpp $(USER_DIR)/Graph.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/graphTest.cpp -o $@

$(USER_DIR)/graphTest : $(USER_OBJ)/Graph.o $(USER_OBJ)/graphTest.o $(GTEST_MAIN)/gtest.a
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@

#################################################
# Shell
#################################################

$(USER_DIR)/shell : $(USER_OBJ)/Graph.o $(USER_OBJ)/shell.o 
	$(CXX) $^ -Wall -g -o $@

$(USER_OBJ)/shell.o : $(USER_DIR)/shell.cpp $(USER_DIR)/shell.h $(USER_DIR)/Graph.h
	$(CXX) $(CXXFLAGS) -c $(USER_DIR)/shell.cpp -o $@

