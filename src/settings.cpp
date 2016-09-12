// Project: TLJSaga
//
// File: settings.h
// Use:  Header for interacting with application settings
// Version: 0.0.0 Alpha
//
// Copyright © 2016 Kristian Høy Horsberg
// All Rights Reserved
//
// Author: Kristian Høy Horsberg <khh1990@gmail.com>
//

#include "website.h"
#include "settings.h"

bool settings::initilized = false;
cppcms::json::value settings::value;