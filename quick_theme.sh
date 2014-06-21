#!/bin/bash

# Script to very quickly explore pelican themes

for t in `ls -d ~/repos/pelican-themes/*`; do
  # directory might contain README files or other files
  if [ -d "${t}" ]; then
    THEME_NAME=`basename $t`;
    echo $THEME_NAME;
    sed s/THEMECHANGE/$THEME_NAME/ pelicanconf_template.py > pelicanconf.py;
    make html;
    echo "Press a key to continue";
    read x;
  fi
done

