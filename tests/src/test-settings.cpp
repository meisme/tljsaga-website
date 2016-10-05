// Project: TLJSaga-tests
//
// File: test-utility.cpp
// Use:  Test the settings modeule
// Version: 0.0.0 Alpha
//
// Copyright © 2016 Kristian Høy Horsberg
// All Rights Reserved
//
// Author: Kristian Høy Horsberg <khh1990@gmail.com>
//

// Catch framework
#include "catch.hpp"

// Include Utility
#include "../../src/settings.h"

// Standard library
#include <chrono>
#include <ctime>
#include <string>


TEST_CASE( "settings throws if called uninitilized", "[settings][!throws]" ) {
	REQUIRE_THROWS(settings::get<int>("root"));
}
