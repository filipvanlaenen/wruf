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
# Initializes WRUF.
#

echo "Initializing WRUF:"

if [ -d "$LOCALWRUFDIR" ]; then
	echo "Local WRUF directory already exists."
else
    mkdir "$LOCALWRUFDIR"
	echo "Created a local WRUF directory: $LOCALWRUFDIR"
fi

if [ -d "${LOCALWRUFDIR}/cache" ]; then
	echo "Local WRUF cache directory already exists."
else
    mkdir "${LOCALWRUFDIR}/cache"
	echo "Created a local WRUF directory: $LOCALWRUFDIR/cache"
fi

$RUBY -I "${WRUFDIR}/lib" "${WRUFDIR}/wruf_init.rb" "${LOCALWRUFDIR}" 

echo "Initialization of WRUF done."

echo "Use 'wruf tags' to set the tags to be used by WRUF."