#!/bin/csh

set path = ( $HOME/bin cerebro/home/software/bin $path)

source /cerebro/home/software/etc/cshrc
source /cerebro/home/software/etc/cshrc.gcc451
source /cerebro/home/software/etc/cshrc.intel14

setenv BUILD TDC-centos-5.9-intel-14.04-mkl-release
setenv SITE cerebro.chem.vt.edu
setenv PSI4_TMPDIR /scratch/crawdad/$BUILD
mkdir -p $PSI4_TMPDIR
setenv NPROCS 4
setenv CTEST_MAKE_NUM_PROCS $NPROCS
setenv TMP_DIR /scratch/crawdad/$BUILD/psi4
mkdir -p $TMP_DIR
setenv PSI4DATADIR $TMP_DIR/lib
mkdir -p $PSI4_TMPDIR/psi4scr
setenv PSI4_SCRATCH $PSI4_TMPDIR/psi4scr

git clone git@github.com:psi4/psi4.git $TMP_DIR

cd $TMP_DIR

./setup --prefix=$HOME/psi4 --cc=icc --cxx=icpc --python=$HOME/bin/python --boost-incdir=$HOME/boost/include --boost-libdir=$HOME/boost/lib --type=release -D BUILDNAME=$BUILD -D SITE=$SITE build

cd $TMP_DIR/build

ctest -D Nightly -j$NPROCS

cd
rm -rf $PSI4_TMPDIR $TMP_DIR

exit 0
