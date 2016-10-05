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

template<class T> class return_value {
public:
	return_value(const T& value, bool good = true) : _value(value), _good(good) {}
	return_value() : _good(false) {}

	bool good() const {
		return _good;
	}

	bool bad() const {
		return !_good;
	}

	bool operator !() const{
		return !_good;
	}

	bool operator ==(const return_value<T>& other) const {
		return _good == other._good && _value == other._value;
	}

	inline bool operator!=(const return_value<T>& other) const {
		return !(*this == other);
	}

	operator T() const {
		return _value;
	}

	T value() const {
		return _value;
	}

	const T& reference() const {
		return _value;
	}

private:
	T _value;
	bool _good;
};

template<class T> return_value<T> make_return_value(const T& value, bool good = true) {
	return return_value<T>(value, good);
}
