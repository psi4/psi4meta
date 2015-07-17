#!/bin/csh -f

set path = ($HOME/bin $path)

source /etc/profile.d/vt-modules.csh

module load intel/15.3
module load mkl/11.2.3
module load openmpi
module list

which icc
which icpc
which ifort
which cmake
which git

setenv BUILD TDC-centos-6.3-intel-15.3-mkl-release
setenv SITE blueridge.chem.vt.edu
setenv PSI4_TMPDIR /work/blueridge/crawdad/scratch/$BUILD
mkdir -p $PSI4_TMPDIR
setenv NPROCS 4
setenv CTEST_MAKE_NUM_PROCS $NPROCS
setenv TMP_DIR /work/blueridge/crawdad/scratch/$BUILD/psi4
mkdir -p $TMP_DIR
setenv PSI4DATADIR $TMP_DIR/lib
mkdir -p $PSI4_TMPDIR/psi4scr
setenv PSI4_SCRATCH $PSI4_TMPDIR/psi4scr

git clone git@github.com:psi4/psi4.git $TMP_DIR

cd $TMP_DIR

./setup --prefix=$HOME/psi4 --cc=icc --cxx=icpc --fc=ifort --boost-incdir=$HOME/boost/include --boost-libdir=$HOME/boost/lib --python=$HOME/bin/python --type=release -D BUILDNAME=$BUILD -D SITE=$SITE build

cd $TMP_DIR/build

ctest -D Nightly -j$NPROCS

cd
rm -rf $PSI4_TMPDIR $TMP_DIR

exit
