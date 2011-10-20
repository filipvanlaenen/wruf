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
# Installs WRUF into /opt, and creates a link from /usr/bin to the wruf script.
#
# Note: Requires root permissions to create the directory. Use sudo to execute this script.
#

WRUFDIR="/opt/wruf"

if [ -d "$WRUFDIR" ]; then
    rm -R "$WRUFDIR"
fi

mkdir "$WRUFDIR"
mkdir "$WRUFDIR/lib"

cp lib/*.rb "$WRUFDIR/lib"

cp wruf* "$WRUFDIR"
chmod a+x "$WRUFDIR/wruf.sh"
chmod a+x "$WRUFDIR/wruf_check_installation.sh"
chmod a+x "$WRUFDIR/wruf_current.sh"
chmod a+x "$WRUFDIR/wruf_init.sh"
chmod a+x "$WRUFDIR/wruf_run.sh"
chmod a+x "$WRUFDIR/wruf_tags.sh"
ln -f "$WRUFDIR/wruf.sh" /usr/bin/wruf

LOG4R=$(gem list log4r | awk '/log4r/ {print $1}')
if [ ${#LOG4R[@]} -eq "0" ]; then
	gem install -r log4r
fi
