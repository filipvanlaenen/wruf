#!/bin/sh
#
# Initializes WRUF.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

echo "Initializing WRUF:"

WRUFDIR="/opt/wruf"
LOCALWRUFDIR="${HOME}/.wruf"
RUBY="ruby"

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