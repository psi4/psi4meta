#!/usr/bin/zsh

export BUILD=JMT-ubuntu-10.4-gcc-4.9.2-debug
export SITE=ccqc.uga.edu
export PSI4_TMPDIR=/tmp/jturney/$BUILD
export TMP_DIR=$PSI4_TMPDIR/psi4
export PSI4DATADIR=$TMP_DIR/lib
export PSI4_SCRATCH=$PSI4_TMPDIR/psi4scr

export NPROCS=4
export CTEST_MAKE_NUM_PROCS=$NPROCS

mkdir -p $PSI4_TMPDIR
mkdir -p $TMP_DIR
mkdir -p $PSI4_SCRATCH

git clone --depth=1 git@github.com:psi4/psi4.git $TMP_DIR

cd $TMP_DIR

./setup --cc=gcc --cxx=g++ --type=debug -DBUILDNAME=$BUILD -DSITE=$SITE -DBUILD_CUSTOM_BOOST=True build

cd $TMP_DIR/build

ctest -D Nightly -j$NPROCS

rm -rf $PSI4_TMPDIR $TMP_DIR

exit 0

