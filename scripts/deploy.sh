#!/bin/bash
############################################
#
# MILO @ 2016
#
# Deploy script for Milo Code Database
#
############################################ 

if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
  echo "Usage: $(basename $0) qtIfwPath"
  echo "This will only work when invoked from root dir"
  echo
  echo "Builds all subproject documentation, cleans up build dirs, creates the "
  echo "Milo DB installer and uploads it to Seafile"
  exit
fi

echo "Updating repository"
git submodule update --init

DOXYGEN=($which doxygen)
QTIFW=$1
FILE=build/miloinstaller_$(date +%Y.%m.%d).run
DOMAIN=https://seafile.milosolutions.com
REPO=$MILOCODEDATABASE_SEAFILE_REPO
USER=$MILOVM_SEAFILE_USER
PASSWORD=$MILOVM_SEAFILE_PASSWORD

echo "Building installer"
./scripts/build_unix.sh $DOXYGEN $QTIFW

echo "Uploading to Seafile"
./scripts/upload_to_seafile.sh -f $FILE -s $DOMAIN -r $REPO -u $USER -p $PASSWORD

echo "Uploading documentation to qtdocs.milosolutions.com"
echo "  To update online docs, please push your changes to GitLab. CI will handle"
echo "  doc building for you."
echo "Done."

