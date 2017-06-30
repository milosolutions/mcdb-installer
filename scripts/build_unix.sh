#!/bin/sh
if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
  echo "Usage: $(basename $0) doxygenPath qtIfwPath"
  echo "This will only work when invoked from root repo dir"
  echo
  echo "Builds all subproject documentation, cleans up build dirs, creates the "
  echo "Milo DB installer"
  exit
fi

if [ "$#" -ne 2 ]; then
  echo "Illegal number of parameters: $#. See --help"
  exit 1
fi

if [ ! -f "$PWD/mcdb-installer.doxyfile" ]; then
  echo "Wrong directory. Call this script from root dir of Milo Code Database"
  exit 2
fi

DOXY=$1
IFW=$2
LOGFILE=$(pwd)/build/build-log.txt

# Takes one argument: path to subproject
prepareSubproject() {
  echo "Subproject "$(basename $1) | tee -a $LOGFILE
  TEMP=$PWD
  cd $1 >> $LOGFILE 2>&1
  echo "  Removing build artifacts" | tee -a $LOGFILE
  rm -rfv build-* >> $LOGFILE 2>&1
  rm *.pro.user >> $LOGFILE 2>&1
  echo "  Building documentation" | tee -a $LOGFILE
  $DOXY *.doxyfile >> $LOGFILE 2>&1
  echo "  Done" | tee -a $LOGFILE
  cd $TEMP
}

echo "Removing build artifacts from base package" | tee $LOGFILE
rm -rfv packages/com.milosolutions.newprojecttemplate/build-* >> $LOGFILE 2>&1

echo "Preparing subprojects" | tee -a $LOGFILE
prepareSubproject packages/com.milosolutions.mbarcodescanner/data/milo/mbarcodescanner
prepareSubproject packages/com.milosolutions.mcripts/data/milo/mscripts
prepareSubproject packages/com.milosolutions.msentry/data/milo/msentry
prepareSubproject packages/com.milosolutions.mcharts/data/milo/mcharts
prepareSubproject packages/com.milosolutions.mconfig/data/milo/mconfig
prepareSubproject packages/com.milosolutions.mlog/data/milo/mlog
prepareSubproject packages/com.milosolutions.mrestapi/data/milo/mrestapi
prepareSubproject packages/com.milosolutions.newprojecttemplate/data
# Build main docs last - so that they can connect TAGFILES properly
prepareSubproject .

echo "Building installer" | tee -a $LOGFILE
$IFW -v -c config/config.xml -p packages build/miloinstaller_$(date +%Y.%m.%d).run >> $LOGFILE 2>&1

echo "Done. If nothing failed, the installer is built. Check build/build-log.txt for details" | tee -a $LOGFILE

