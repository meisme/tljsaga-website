// Project: TLJSaga
//
// File: return_value.h
// Use:  Class to box return values with a flag indicating if call was successful
// Version: 0.0.0 Alpha
//
// Copyright © 2016 Kristian Høy Horsberg
// All Rights Reserved
//
// Author: Kristian Høy Horsberg <khh1990@gmail.com>
//

#pragma once

template <class T> class return_value {
public:
	return_value(T value, bool good = true) : _value(value), _good(good) {}
	return_value() : _good(false) {}

	bool good() {
		return _good;
	}

	operator T() {
		return value;
	}

	T value() {
		return _value;
	}

	const T& reference() {
		return _value;
	}

private:
	T _value;
	bool _good;
};
