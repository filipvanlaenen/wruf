#!/bin/sh
#
# Central point to run WRUF. The script accepts the following arguments:
# - run: To run WRUF
# - version: To display version information
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

WRUFDIR="/opt/wruf"
VERSION="0.1"
ACTION="$1"

case "$ACTION" in
  init)
    ${WRUFDIR}/wruf_init.sh
    ;;
  run)
    ${WRUFDIR}/wruf_run.sh
    ;;
  version)
    echo "Wallpaper Rotator Using Flickr (WRUF) version ${VERSION}"
    ;;    
  *)
    echo "Usage: wruf {init|run|version}" >&2
    exit 1
    ;;
esac

