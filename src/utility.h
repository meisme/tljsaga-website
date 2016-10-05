// Project: TLJSaga
//
// File: utility.h
// Use:  Precompiled header for project
// Version: 0.0.0 Alpha
//
// Copyright © 2016 Kristian Høy Horsberg
// Available under version 3 of GNU Affero General Public License
//
// Author: Kristian Høy Horsberg <khh1990@gmail.com>
//

#ifndef UTILITY_H
#define UTILITY_H

//#include "website.h"
#include <string>
#include <chrono>
#include <ctime>

namespace utility {

typedef std::chrono::system_clock clock_t;
typedef clock_t::time_point time_point_t;

// Format a date with UTC
std::string date(std::string format, time_point_t time);
std::string date(std::string format = "%F %T");

// Format a date with local time
std::string datel(std::string format, time_point_t time);
std::string datel(std::string format = "%F %T");

} // namespace utility

#endif // UTILITY_H
