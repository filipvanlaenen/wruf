#!/bin/sh
#
# Creates an installation package.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

# Create an empty temporary directory

SCRIPTDIR="$( cd "$( dirname "$0" )" && pwd )"
VERSION="0.1"
TEMPDIR="wruf-${VERSION}"

if [ -d "$TEMPDIR" ]; then
    rm -R "$TEMPDIR"
fi

mkdir "$TEMPDIR"

# Copy all resources to the temporary directory

BINDIR=${SCRIPTDIR}/../bin
cp ${BINDIR}/install.sh "$TEMPDIR"
cp ${BINDIR}/wruf.sh "$TEMPDIR"
cp ${BINDIR}/wruf_run.rb "$TEMPDIR"
cp ${BINDIR}/wruf_run.sh "$TEMPDIR"

DOCDIR=${SCRIPTDIR}/../doc
cp ${DOCDIR}/readme.txt "$TEMPDIR"

LIBDIR=${SCRIPTDIR}/../lib
mkdir "${TEMPDIR}/lib"
cp ${LIBDIR}/*.rb "${TEMPDIR}/lib"

# Creates the archive file

TARFILE="wruf-${VERSION}.tar.gz"
tar -pczf $TARFILE "$TEMPDIR"

# Remove the temporary directory

rm -R $TEMPDIR