// Project: TLJSaga
//
// File: utility.h
// Use:  Precompiled header for project
// Version: 0.0.0 Alpha
//
// Copyright © 2016 Kristian Høy Horsberg
// All Rights Reserved
//
// Author: Kristian Høy Horsberg <khh1990@gmail.com>
//

#include "utility.h"
#include <memory>

namespace utility {

namespace impl {
std::string date(std::string format, const std::tm* time) {
	/*
	// USE WHEN put_time IS SUPPORTED BY GCC
	std::stringstream ss;
	ss << std::put_time(std::localtime(&in_time_t), format.c_str());
	return ss.str();*/

	// Allocate buffer
	const int BUFFER_SIZE = 100;
	char buffer[BUFFER_SIZE];

	// use ctime to format string
	std::strftime(buffer, BUFFER_SIZE, format.c_str(), time);
	return std::string(buffer);
}
} // namespace impl

std::string date(std::string format) {
	return date(format, clock_t::now());
}

std::string date(std::string format, time_point_t time) {
	auto in_time = clock_t::to_time_t(time);
	return impl::date(format, std::gmtime(&in_time));
}

std::string datel(std::string format) {
	return date(format, clock_t::now());
}

std::string datel(std::string format, time_point_t time) {
	auto in_time = clock_t::to_time_t(time);
	return impl::date(format, std::localtime(&in_time));
}

} // namespace datetime
