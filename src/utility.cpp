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

namespace utility {

std::string date(std::string format) {
	return date(format, std::chrono::system_clock::now());
}

std::string date(std::string format, time_point_t time) {
	auto in_time_t = std::chrono::system_clock::to_time_t(time);

	/*
	// USE WHEN put_time is supported by GCC in use
	std::stringstream ss;
	ss << std::put_time(std::localtime(&in_time_t), format.c_str());
	return ss.str();*/

	// Allocate buffer
	const int BUFFER_SIZE = 100;
	char buffer[BUFFER_SIZE];

	// use ctime to format string
	std::strftime(buffer, BUFFER_SIZE, format.c_str(), std::localtime(&in_time_t));
	return std::string(buffer);
}

} // namespace datetime
