Wallpaper Rotator Using Flickr (WRUF)
Copyright © 2011 Filip van Laenen <f.a.vanlaenen@ieee.org>

This file is part of WRUF.

WRUF is free software: you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
 
WRUF is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
Public License for more details.
 
You can find a copy of the GNU General Public License in /doc/gpl.txt


                INSTALLATION INSTRUCTIONS


These are the installation instructions for WRUF.

1. INSTALLATION

1.1 UBUNTU

* Install Ruby and Gem.
* Install rsvg-convert.
* Unpack the bundle file, e.g. using the following command:
	tar -xzf wruf-<version-number>.tar.gz
* Navigate into the root directory of the unpacked bundle, e.g. using the following command:
	cd wruf-<version-number>
* Install the package by running the install.sh script with root privileges, e.g. by doing:
	sudo ./install.sh
  Notice that it will try to install the gem log4r if it isn't installed yet.
	
2. CONFIGURATION

* Try to run WRUF using the following command:
	wruf init
* Set the tags to be used by WRUF using the following command:
    wruf tags

3. RUNNING WRUF

* You can run WRUF using the following command:
    wruf run

4. ADDING WRUF TO CRONTAB

* You can add WRUF to the Crontab using the following command:
	crontab -e
  It's probably a good idea to let WRUF run once every hour. To do this, add the following line to
  Crontab, replacing '1' with the appropriate number for the minutes (anything from 0 to 59 will
  do):
    1 * * * * DISPLAY=:0.0 /usr/bin/wruf run
  You have to include DISPLAY in order to let the script work from the crontab.