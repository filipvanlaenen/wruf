#!/bin/sh
#
# Starts to run WRUF
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

WRUFDIR="/opt/wruf"
LOCALWRUFDIR="${HOME}/.wruf"
RUBY="ruby"

if [ ! -d "$LOCALWRUFDIR" ]; then
	echo "Local WRUF directory does not exist -- (re)run initialization before trying to run WRUF."
	exit
fi

if [ ! -e "$LOCALWRUFDIR/wruf-config.yaml" ]; then
	echo "Local WRUF configuration file does not exist -- (re)run initialization before trying to run WRUF."
	exit
fi

if [ ! -d "$LOCALWRUFDIR/cache" ]; then
	echo "Local WRUF cache directory does not exist -- (re)run initialization before trying to run WRUF."
	exit
fi

$RUBY -I "${WRUFDIR}/lib" "${WRUFDIR}/wruf_run.rb" "${LOCALWRUFDIR}" &