TLJSaga website readme
======================

## Status ##
[![Build Status](https://api.shippable.com/projects/57f54b2bca30990e0038408f/badge?branch=master)](https://app.shippable.com/projects/57f54b2bca30990e0038408f)

## Build ##
### Linux ###
To build the application on Linux run `make && make test`

### Windows ###
Build the application using the MSVC solution on the win32 directory. The
solution requres MSVC 2015 or greater, though the files will probably build on
older version as well.

## Mac OSX ##
Not tested on Mac, but it should be possilbe to use the Linux build with few
modifications.

## Dependencies ##
Libraries:
 - cppcms version >= 1.0.5
 - booster (part of cppcms)

## Optional dependencies ##
For building tests:
 - Catch (unit test framework for C++) †

For test code coverage reports:
 - GCC
 - gcovr (from PyPI)

† Automatically downloaded by `make` on Linux

## Encoding ##
All text files should be UTF-8 without BOM and anything else is considered a
bug, except for the Visual Studio solution and project files which use MSVC's
default encoding.

## License ##
This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along
with this program. If not, see <http://www.gnu.org/licenses/>.
