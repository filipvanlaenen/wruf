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
# Does an operation on the current wallpaper:
#  - Dislike: Rotates the wallpaper regardless of when it was rotated last.
#

OPERATION="$1"

case "$OPERATION" in
  dislike)
    ${WRUFDIR}/wruf_check_installation.sh
    $RUBY -I "${WRUFDIR}/lib" "${WRUFDIR}/wruf_current_dislike.rb" "${LOCALWRUFDIR}"
    ;;
  *)
    echo "Allowed operations on the current wallpaper:"
    echo " - dislike: Rotates the wallpaper regardless of when it was rotated last."
    exit 1
    ;;
esac

