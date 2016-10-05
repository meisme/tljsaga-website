TLJSaga website readme
======================

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
This software depends on the C++ libraries:
  - cppcms
  - booster (part of cppcms)

Additionally the software requires these build dependencies:
  - Catch (unit test framework for C++) †

† Automatically downloaded on Linux by running `make`

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
