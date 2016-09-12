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

#ifndef UTILITY_H
#define UTILITY_H

#include "website.h"

namespace utility {

typedef std::chrono::system_clock::time_point time_point_t;

// Format a date
std::string date(std::string format = "%F %T");
std::string date(std::string format, time_point_t time);

} // namespace utility

#endif // UTILITY_H
