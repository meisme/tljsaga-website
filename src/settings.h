// Project: TLJSaga
//
// File: settings.h
// Use:  Header for interacting with application settings
// Version: 0.0.0 Alpha
//
// Copyright © 2016 Kristian Høy Horsberg
// Available under version 3 of GNU Affero General Public License
//
// Author: Kristian Høy Horsberg <khh1990@gmail.com>
//

#pragma once

#include "website.h"
#include "return_value.h"

class settings {
public:
	static void init(const cppcms::json::value& value) {
		if (!initilized) {
			settings::value = value;
			initilized = true;
		}
	}

	template <class T> static return_value<T> get(const char* key) {
		check();
		try {
			auto v = value.at(key);
			return return_value<T>(v.get_value<T>());
		} catch (cppcms::json::bad_value_cast& e) {
			BOOSTER_WARNING("settings::get") << "Attempted to access non-existant settings path «"
				<< key << "»: " << e.what();
			return return_value<T>();
		}
	}

	template <class T> static return_value<T> get(const std::string& key) {
		return get<T>(key.c_str());
	}

private:
	static bool initilized;
	static cppcms::json::value value;

	static void check() {
		if (!initilized) {
			throw std::runtime_error("settings::get called before settings::init");
		}
	}

public:
	settings() = delete;
	settings(settings const&) = delete;
	void operator=(settings const&) = delete;
};
