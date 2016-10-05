// Project: TLJSaga-tests
//
// File: test-utility.cpp
// Use:  Test the utility module
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
#include "../../src/utility.h"

// Standard library
#include <chrono>
#include <ctime>
#include <string>


TEST_CASE( "utility date function formats correctly", "[utility]" ) {

	SECTION("produces same result as C's strftime") {
		utility::time_point_t timepoint = utility::clock_t::now();
		std::string format = "%F %T";
		auto date_string = utility::date(format, timepoint);
		const int BUFSIZE = 256;
		char buffer[BUFSIZE];
		auto in_time = utility::clock_t::to_time_t(timepoint);
		std::strftime(buffer, BUFSIZE, format.c_str(), std::gmtime(&in_time));
		std::string strftime_string = buffer;

		REQUIRE(date_string == strftime_string);
	}

	SECTION( "Handles epoch dates" ) {
		std::time_t timestamp = 1475630520;
		std::string date_string = utility::date("%F %T", utility::clock_t::from_time_t(timestamp));

		REQUIRE(date_string == "2016-10-05 01:22:00");
	}
}
