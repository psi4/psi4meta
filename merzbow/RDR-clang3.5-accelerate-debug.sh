#!/bin/bash

source /Users/roberto/.bashrc
export PATH=/opt/intel/composer_xe_2015.0.077/bin/intel64:/opt/intel/composer_xe_2015.0.077/mpirt/bin/intel64:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/opt/intel/composer_xe_2015.0.077/debugger/gdb/intel64/bin

PSI4_TMPDIR=/Users/roberto/Scratch/RDR-clang3.5-accelerate-debug
mkdir -p $PSI4_TMPDIR
export PSI4_TMPDIR
export NPROCS=`sysctl -n hw.ncpu`
export CTEST_MAKE_NUM_PROCS=$NPROCS

TMP_DIR=/Users/roberto/Scratch/tmprunpsi4/RDR-clang3.5-accelerate-debug
mkdir -p $TMP_DIR

git clone git@github.com:psi4/psi4.git $TMP_DIR

cd $TMP_DIR

./setup --fc=gfortran --cc=clang --cxx=clang++ --type=debug --plugins=on --accelerate -D BUILDNAME=RDR-MacOS-10.10.4-clang3.5-accelerate-debug -D SITE=merzbow --python=/usr/local/bin/python

cd $TMP_DIR/objdir

export PSI4DATADIR=$TMP_DIR/lib
mkdir -p $PSI4_TMPDIR/psi4scr
export PSI4_SCRATCH=$PSI4_TMPDIR/psi4scr

ctest -D Nightly -j$NPROCS

cd
rm -rf $PSI4_TMPDIR $TMP_DIR

exit 0
