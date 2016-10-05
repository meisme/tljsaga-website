// Project: TLJSaga tests
//
// File: test-return_value.cpp
// Use:  Test the settings modeule
// Version: 0.0.0 Alpha
//
// Copyright © 2016 Kristian Høy Horsberg
// Available under version 3 of GNU Affero General Public License
//
// Author: Kristian Høy Horsberg <khh1990@gmail.com>
//

// Catch framework
#include "catch.hpp"

// Include Utility
#include "../../src/return_value.h"

// Standard library
#include <string>

// Convert to string
template<class T>std::ostream& operator << (std::ostream& os, const return_value<T>& value ) {
    os << value.reference() << (value.good()?"(good)":"(bad)");
    return os;
}

// Test case
TEST_CASE ( "return_value works as expected", "[return_value][Utility]" ) {
	typedef int int_t;
	typedef std::string string_t;

	const int_t INTVALUE = 256;
	const string_t STRINGVALUE = "A string of characters";

	auto rvi = make_return_value(INTVALUE);
	auto rvs = make_return_value(STRINGVALUE);

	auto rvi_bad = make_return_value(INTVALUE, false);
	auto rvs_bad = make_return_value(STRINGVALUE, false);

	SECTION ( "make_return_value equality" ) {
		REQUIRE(rvi == return_value<int_t>(INTVALUE));
		REQUIRE(rvs == return_value<string_t>(STRINGVALUE));
		REQUIRE(rvi_bad == return_value<int_t>(INTVALUE, false));
		REQUIRE(rvs_bad == return_value<string_t>(STRINGVALUE, false));
	}

	SECTION ( "equality operators" ) {
		auto rvi2 = make_return_value(INTVALUE-1);

		REQUIRE_FALSE(rvi_bad == rvi2);
		REQUIRE_FALSE(rvi == rvi_bad);
		REQUIRE(rvi != rvi_bad);
		REQUIRE(rvi != rvi2);
	}

	SECTION ( "default initilized to good state" ) {
		REQUIRE(rvi.good());
		REQUIRE(rvs.good());
	}

	SECTION ( "good() and bad() member functions opposite of each other" ) {
		REQUIRE(rvi.good() == !rvi.bad());
		REQUIRE(rvs.good() == !rvs.bad());
		REQUIRE(rvi_bad.good() == !rvi_bad.bad());
		REQUIRE(rvs_bad.good() == !rvs_bad.bad());

	}

	SECTION ( "can be initilized to bad state" ) {
		REQUIRE(rvi_bad.bad());
		REQUIRE(rvs_bad.bad());
	}

	SECTION ( "properly supports operator !" ) {
		REQUIRE_FALSE(!rvi);
		REQUIRE_FALSE(!rvs);

		REQUIRE(!rvi_bad);
		REQUIRE(!rvs_bad);
	}

	SECTION ( "can retrieve original value" ) {
		REQUIRE(rvi.value() == INTVALUE);
		REQUIRE(rvs.value() == STRINGVALUE);

		REQUIRE(static_cast<int_t>(rvi) == INTVALUE);
		REQUIRE(static_cast<string_t>(rvs) == STRINGVALUE);
	}

}
