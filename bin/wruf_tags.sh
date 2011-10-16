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
# Starts an interactive dialogue with the user to manage the tags.
#

WRUFDIR="/opt/wruf"
LOCALWRUFDIR="${HOME}/.wruf"
RUBY="ruby"

${WRUFDIR}/wruf_check_installation.sh

echo "Wallpaper Rotator Using Flickr (WRUF) v${VERSION} - Tag Management"
echo "Copyright © ${COPYRIGHTYEAR} Filip van Laenen <f.a.vanlaenen@ieee.org>"
echo

$RUBY -I "${WRUFDIR}/lib" "${WRUFDIR}/wruf_tags.rb" "${LOCALWRUFDIR}"