aruba-iotops-ble-classification-apps
====================================

BLE classification apps for Aruba IoT Operations.


Classification Apps
-------------------

The following classification apps are included.

### interoperable-identifier

Classifies [InteroperaBLE Identifiers](https://reelyactive.github.io/interoperable-identifier/) embedded in iBeacon or Eddystone-UID packets.  See the [lua/interoperable-identifier.lua](lua/interoperable-identifier.lua) script.

To test the classifier, from the root of this repository, run the following:

    bin/interoperable-identifier

The following InteroperaBLE Identifier cases will be tested, with properties printed to the console:
- .mp3
- Unicode Code Points
- DirAct
- Motion
- Button


Lua Style Guide
---------------

The following practices are observed by [reelyActive](https://www.reelyactive.com) for coding Aruba IoT Operations classification apps in Lua:
- two spaces for indentation
- lowerCamelCase for variable names
- SCREAMING_SNAKE_CASE for constants
- 80-character limit


Lua Installation
----------------

[Lua](https://www.lua.org/) must be installed to run the test scripts in the bin folder.  For example, install on Ubuntu with `sudo apt-get install lua5.4` or a more recent [Lua version](https://www.lua.org/versions.html), if available.


Contributing
------------

Discover [how to contribute](CONTRIBUTING.md) to this open source project which upholds a standard [code of conduct](CODE_OF_CONDUCT.md).


Security
--------

Consult our [security policy](SECURITY.md) for best practices using this open source software and to report vulnerabilities.


License
-------

MIT License

Copyright (c) 2025 [reelyActive](https://www.reelyactive.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
THE SOFTWARE.