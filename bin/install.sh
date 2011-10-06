#!/bin/sh
#
# Installs WRUF into /opt, and creates a link from /usr/bin to the wruf script.
#
# Note: Requires root permissions to create the directory. Use sudo to execute this script.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

WRUFDIR="/opt/wruf"
VERSION="0.1"

if [ -d "$WRUFDIR" ]; then
    rm -R "$WRUFDIR"
fi

mkdir "$WRUFDIR"
mkdir "$WRUFDIR/lib"

cp lib/*.rb "$WRUFDIR/lib"

cp wruf* "$WRUFDIR"
chmod a+x "$WRUFDIR/wruf.sh"
chmod a+x "$WRUFDIR/wruf_run.sh"
ln -f "$WRUFDIR/wruf.sh" /usr/bin/wruf

LOG4R=$(gem list log4r | awk '/log4r/ {print $1}')
if [ ${#LOG4R[@]} -eq "0" ]; then
	gem install -r log4r
fi
