#!/bin/bash

export BUILD=TDC-MacOC-10.10.4-llvm-6.0-accelerate-release 
export SITE=ganymede
export PSI4_TMPDIR=/tmp/$BUILD
mkdir -p $PSI4_TMPDIR
export NPROCS=4
export CTEST_MAKE_NUM_PROCS=$NPROCS
export TMP_DIR=/tmp/$BUILD/psi4
mkdir -p $TMP_DIR
export PSI4DATADIR=$TMP_DIR/lib
mkdir -p $PSI4_TMPDIR/psi4scr
export PSI4_SCRATCH=$PSI4_TMPDIR/psi4scr

git clone git@github.com:psi4/psi4.git $TMP_DIR

cd $TMP_DIR

./setup --prefix=/tmp/$BUILD-install --type=release -D BUILDNAME=$BUILD -D SITE=$SITE build

cd $TMP_DIR/build

ctest -D Nightly -j$NPROCS

cd
rm -rf $PSI4_TMPDIR $TMP_DIR

exit 0
