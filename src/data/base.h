// Project: website
//
// File: data/base.h
// Use:  Base template data structure
// Version: 0.0.0 Alpha
//
// Copyright © 2016 Kristian Høy Horsberg
// All Rights Reserved
//
// Author: Kristian Høy Horsberg <khh1990@gmail.com>
//

#pragma once

#include <string>

#include <cppcms/view.h>

namespace data {

struct base : public cppcms::base_content {
	// Name of the website - used for title and header generation
	static std::string website_name;
};

} // namespace data
