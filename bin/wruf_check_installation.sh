#!/bin/sh
#
# Wallpaper Rotator Using Flickr (WRUF)
# Copyright © 2011 Filip van Laenen <f.a.vanlaenen@ieee.org>
#
# This file is part of WRUF.
#
# WRUF is free software: you can redistribute it and/or modify it under the terms of the GNU General
# Public License as published by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# WRUF is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
# 
# You can find a copy of the GNU General Public License in /doc/gpl.txt
#

#
# Checks that WRUF has been initialized.
#

LOCALWRUFDIR="${HOME}/.wruf"

if [ ! -d "$LOCALWRUFDIR" ]; then
	echo "Local WRUF directory does not exist -- (re)run initialization before trying to run WRUF."
	exit
fi

if [ ! -e "$LOCALWRUFDIR/wruf.yaml" ]; then
	echo "Local WRUF configuration file does not exist -- (re)run initialization before trying to run WRUF."
	exit
fi

if [ ! -d "$LOCALWRUFDIR/cache" ]; then
	echo "Local WRUF cache directory does not exist -- (re)run initialization before trying to run WRUF."
	exit
fi