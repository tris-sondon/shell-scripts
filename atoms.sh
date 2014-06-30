#!/bin/bash

#########################################################################
##   Script to run ATOM program
##
##   Tristana Sondon
##   November 2010
########################################################################

if [ "$1" = "--help" ]; then
    echo "Script to run ATOM progra"
    exit
fi

MY_NAME=`basename $0`

if [ $# -lt 2 -o $# -gt 3 ]; then 
    echo "------ Wrong number of arguments! -----------------"; echo
    echo "Usage: $MY_NAME -a <name.inp> for AE calculations"
    echo "       $MY_NAME -g <name.inp> for PG calculations"
    echo "       $MY_NAME -t <name.inp> <psname.vps> to test ppots "
    exit
fi

#########################################################################
# Set correct paths depending on the machine
#########################################################################

# case "$HOSTNAME" in
#    # Add your hostnames to set PS_PROG_DIR
# esac


ATOM_UTILS_DIR=$PS_PROG_DIR/Tutorial/Utils
ATOM_PROG=$PS_PROG_DIR/atm

#########################################################################
# AE Calculation
########################################################################

if [ "$1" = "-a" ]; then
  if [ $# != 2  ]; then
    echo "Usage: $MY_NAME -a <name.inp> for AE calculations"
  else
    echo "Runing AE calculation"
    FILE=$2
    NAME=`basename $2 .inp`
    if [ -d $NAME ]; then
        echo "Directory $NAME exists. Please delete it first"
        exit
    fi
    mkdir $NAME 
    cd $NAME
    cp ../$FILE ./INP
    $ATOM_PROG
    echo "==> Output data in directory $NAME"
    for i in charge vcharge vspin ae ; do
        cp -f ${ATOM_UTILS_DIR}/$i.gps .
        cp -f ${ATOM_UTILS_DIR}/$i.gplot .
    done
  fi
fi

#########################################################################
# Pseudo Potential Generation
#########################################################################

if [ "$1" = "-g" ]; then
  if [ $# != 2 ]; then
    echo "Usage: $MY_NAME -g <name.inp> for pseudo-potential generation"
  else
    echo "Runing pseudo-potential generation"
    FILE=$2
    NAME=`basename $2 .inp`
    if [ -d $NAME ]
    then
        echo "Directory $NAME exists. Please delete it first"
        exit
    fi
    mkdir $NAME 
    cd $NAME
    cp ../$FILE ./INP
    $ATOM_PROG
    cp VPSOUT ../$NAME.vps
    cp VPSFMT ../$NAME.psf
    echo "==> Output data in directory $NAME"
    echo "==> Pseudopotential in $NAME.vps and $NAME.psf "
    for i in charge vcharge vspin coreq pots pseudo scrpots subps ; do
        cp -f ${ATOM_UTILS_DIR}/$i.gps .
        cp -f ${ATOM_UTILS_DIR}/$i.gplot .
    done
  fi
fi

#########################################################################
# Testing Pseudo-Potentials
#########################################################################

if [ "$1" = "-t" ]; then
  if [ $# != 3 ]; then
    echo "Usage: $MY_NAME -t <name.inp> <psname.vps> to test pseudo-potentials"
  else
    echo "Runing pseudo-potential test calculation"
    FILE=$2
    PSFILE=$3
    PTNAME=`basename $FILE .inp`
    PSNAME=`basename $PSFILE .vps`
    NAME="$PTNAME-$PSNAME"
    if [ -d $NAME ]; then
        echo "Directory $NAME exists. Please delete it first"
        exit
    fi
    mkdir $NAME 
    cd $NAME
    cp ../$FILE ./INP
    cp ../$PSFILE ./VPSIN
    $ATOM_PROG
    echo "==> Output data in directory $NAME"
    for i in charge vcharge vspin pt  ; do
            cp -f ${ATOM_UTILS_DIR}/$i.gps .
            cp -f ${ATOM_UTILS_DIR}/$i.gplot .
    done
  fi
fi


