// Project: TLJSaga
//
// File: website.cpp
// Use:  Main website implementation
// Version: 0.0.0 Alpha
//
// Copyright © 2016 Kristian Høy Horsberg
// All Rights Reserved
//
// Author: Kristian Høy Horsberg <khh1990@gmail.com>
//

#include "website.h"

#include "settings.h"

#include "data/base.h"

#include "utility.h"

class website : public cppcms::application {
public:
	// Main website application
	website(cppcms::service &srv) : cppcms::application(srv) {
		// init settings
		std::string settings_key = "application";
		try {
			settings::init(settings().at(settings_key));
		} catch (const cppcms::json::bad_value_cast& e) {
			BOOSTER_ERROR("website::website") << "Could not access application settings at «"
				<< settings_key << "»: " << e.what();
		}

		/**
		* WIRE VIEWS
		*/
		// View index
		dispatcher().assign("/", &website::view_index, this);
		mapper().assign("index", "/");
		dispatcher().assign("", &website::view_index, this);


		// Root path of application
		auto root_path = settings::get<std::string>("root_path");
		if (root_path.good()) {
			mapper().root(root_path.reference());
		} else {
			mapper().root("/");
		}
	}

	void standard_headers() {
		response().set_header("Vary", "Accept-Encoding");
	}

	void view_index() {
		standard_headers();
		data::base d;
		render("index", d);
	}
};

int MAX_RETRIES = 10;

int main(int argc, char* argv[]) {
	bool error = false;
	int n = 0;
	do {
		++n;
		if (error) {
			std::cerr << utility::date() << " [ERROR] Application crashed, restarting application (" << n << '/' << MAX_RETRIES << ")" << std::endl;
		}
		error = false;
		try {
			cppcms::service srv(argc, argv);
			srv.applications_pool().mount(
				cppcms::applications_factory<website>()
			);
			srv.run();
		} catch (std::exception const &e) {
			std::cerr << "[ERROR] " << e.what() << std::endl;
			error = true;
		}
	} while (n < MAX_RETRIES && error);

	if (error) {
		std::cerr << utility::date() << " [FATAL] Application crashed, retries exhausted!" << std::endl;
	}
}
