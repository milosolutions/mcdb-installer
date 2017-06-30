#!/bin/bash
if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
  echo "Usage: $(basename $0)"
  echo "This will only work when invoked from root repo dir"
  echo
  echo "This script applies Milo header to all files (.h, .cpp, .qml) within "
  echo "Milo DB source tree (packages folder). Make sure your repo is up to "
  echo "date (git submodule update)."
  echo
  echo "WARNING: paths should not contain any spaces!"
  exit
fi

HeaderFile="miloheader.md"

if [ ! -f $HeaderFile ]; then
  echo "Milo header file (miloheader.md) has not been found, exiting..."
  exit 1
fi

HeaderData="$(tail -n+4 $HeaderFile)"
HeaderRow="$(tail -n+4 $HeaderFile | head -n1)"
HeaderEnd="$(tail -n2 $HeaderFile | head -n1)"

# Debug
echo "HeaderData: "$HeaderData
echo "HeaderRow: "$HeaderRow
echo "HeaderEnd: "$HeaderEnd

# Recursive iteration through dir tree.
recursiveinsertheader() {
for d in *; do
  if [ -d "$d" ]; then
    (cd "$d"
    echo "Entered $PWD"
    recursiveinsertheader)
  else
    if [[ $d == *.cpp ]] || [[ $d == *.h ]] || [[ $d == *.qml ]]; then
#|| [[ $d == *.js ]]; then
      echo "  Processing $d"
      if grep -q -F "$HeaderRow" "$d"; then
        echo "    Replacing existing header"
        SafeRow=$(printf '%s\n' "$HeaderRow" | sed 's/[[\.*^$/]/\\&/g')
        SafeEnd=$(printf '%s\n' "$HeaderEnd" | sed 's/[[\.*^$/]/\\&/g')
        sed -i "/$SafeRow/,/$SafeEnd/d" $d # > $d.seded
      fi

      # Otherwise, add the header directly
      #echo "    Inserting new header"
      echo "$HeaderData" > $d.temp
      echo "" >> $d.temp
      cat $d >> $d.temp
      cp $d.temp $d
      rm $d.temp
    fi
  fi
done
}

echo "Entering packages directory"
cd packages
recursiveinsertheader
echo "Done. Please check with git diff before committing"

