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

#include "website.h"
#include "settings.h"

bool settings::initilized = false;
cppcms::json::value settings::value;