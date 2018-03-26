#!/bin/sh

# Bail on errors.
set -e

if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
  echo "Usage: $(basename $0) extension qtIfwPath [doxygenPath]"
  echo "This will only work when invoked from root repo dir"
  echo
  echo "Builds all subproject documentation, cleans up build dirs, creates the "
  echo "Milo DB installer"
  exit
fi

if [ $# -lt 2 ]; then
  echo "Illegal number of parameters: "$#". See --help"
  exit 1
fi

if [ ! -f "$PWD/mcdb-installer.doxyfile" ]; then
  echo "Wrong directory. Call this script from root dir of Milo Code Database"
  exit 2
fi

EXTENSION=$1
IFW=$2
DOXY=$3

if [ ! -f "$IFW" ]; then
  echo "Qt Installer Framework has not been found! "$IFW
  exit 3
fi

if [ ! -f "$DOXY" ]; then
  echo "Doxygen has not been found. No worries, this script will still continue "$DOXY
fi

# Takes one argument: path to subproject
prepareSubproject() {
  echo "Subproject $(basename $1)"
  TEMP=$PWD
  cd $1
  echo "  Removing build artifacts"
  rm -rfv build-*
  rm -f *.pro.user
  if [ "$DOXY" != "" ]; then
    echo "  Building documentation"
    $DOXY *.doxyfile
  fi
  echo "  Done"
  cd $TEMP
}

echo "Removing build artifacts from base package"
rm -rfv packages/com.milosolutions.newprojecttemplate/build-*

echo "Preparing subprojects"
prepareSubproject packages/com.milosolutions.mbarcodescanner/data/milo/mbarcodescanner
prepareSubproject packages/com.milosolutions.mscripts/data/milo/mscripts
prepareSubproject packages/com.milosolutions.msentry/data/milo/msentry
prepareSubproject packages/com.milosolutions.mcharts/data/milo/mcharts
prepareSubproject packages/com.milosolutions.mconfig/data/milo/mconfig
prepareSubproject packages/com.milosolutions.mcrypto/data/milo/mcrypto
prepareSubproject packages/com.milosolutions.mlog/data/milo/mlog
prepareSubproject packages/com.milosolutions.mrestapi/data/milo/mrestapi
prepareSubproject packages/com.milosolutions.newprojecttemplate/data
# Build main docs last - so that they can connect TAGFILES properly
prepareSubproject .

echo "Building installer"
$IFW -v -c config/config.xml -p packages build/miloinstaller_$(date +%Y.%m.%d).$EXTENSION

chmod +x ./build/miloinstaller_$(date +%Y.%m.%d).$EXTENSION

echo "Done. If nothing failed, the installer is built. Check build/build-log.txt for details"
