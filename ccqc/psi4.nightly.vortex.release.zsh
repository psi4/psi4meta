#!/usr/bin/zsh

source /etc/profile.d/modules.sh

module load intel/15.0.0.090
module load git
module load cmake/3

export PYTHON=/opt/python/2.7.3/bin/python

export BUILD=JMT-sles-11.3-intel-15.0.0-mkl-release
export SITE=ccqc.uga.edu
export PSI4_TMPDIR=/tmp/jturney/$BUILD
export TMP_DIR=$PSI4_TMPDIR/psi4
export PSI4DATADIR=$TMP_DIR/lib
export PSI4_SCRATCH=$PSI4_TMPDIR/psi4scr

export NPROCS=1
export CTEST_MAKE_NUM_PROCS=$NPROCS

mkdir -p $PSI4_TMPDIR
mkdir -p $TMP_DIR
mkdir -p $PSI4_SCRATCH

git clone --recursive --depth=1 git@github.com:psi4/psi4.git $TMP_DIR

cd $TMP_DIR

./setup --cc=icc --cxx=icpc --python=$PYTHON --type=release --vectorization -DBUILDNAME=$BUILD -DSITE=$SITE -DBUILD_CUSTOM_BOOST=True build

cd $TMP_DIR/build

ctest -D Nightly -j$NPROCS

rm -rf $PSI4_TMPDIR $TMP_DIR

exit 0

