#!/bin/bash

# [LAB, 28 Jun 2016]

# minicondatoss --> minicondadrive

if [ $# -ne 1 ]; then
    echo $0: usage: kitandkaboodle.sh stage1/2
    exit 1
fi
stage=$1

#############
#   PREP    #
#############

export PATH=/theoryfs2/common/software/libexec/git-core:/theoryfs2/ds/cdsgroup/perl5/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin

    # MINIINSTALLER file is only thing in MINIBUILDDIR
MINIBUILDDIR=/theoryfs2/ds/cdsgroup/psi4-build
MINIINSTALLER=Miniconda-latest-Linux-x86_64.sh
NIGHTLYDIR=/theoryfs2/ds/cdsgroup/psi4-compile/psi4meta/conda-recipes
export CONDA_BLD_PATH=/scratch/cdsgroup/conda-builds

VERSION=0.9.6
CHANNEL="localchannel-$VERSION"
VERSION2=0.9.7


#############
#  STAGE 1  #
#############

if [ $stage == "stage1" ]; then

# <<<  Prepare Throwaway Conda Installation w/ Driver  >>>

cd $MINIBUILDDIR
bash $MINIINSTALLER -b -p $MINIBUILDDIR/minicondatoss
export PATH=$MINIBUILDDIR/minicondatoss/bin:$PATH
conda update --yes --all
    # install packages from installer/construct.yaml "driver" section
conda install --yes conda conda-build constructor anaconda-client
conda list

# <<<  Run Constructor of Build/Run  >>>

    # items in $NIGHTLYDIR/installer/construct.yaml
    # - increment and match above VERSION in "version"
    # - free only in "channels"
    # - uncomment build/run
    # - true "keep_pkgs"
    # - comment "post_install"

conda install --yes conda=4.0.9 constructor=1.2.0

cd $NIGHTLYDIR
constructor installer
bash psi4conda-$VERSION-Linux-x86_64.sh -b -p $MINIBUILDDIR/minicondastore-$VERSION
cd $MINIBUILDDIR
mkdir -p "$CHANNEL/linux-64"
cd "$CHANNEL/linux-64"
ln -s $MINIBUILDDIR/minicondastore-$VERSION/pkgs/*bz2 .
    # only do this to skip the psi4 build UNTESTED
#ln -s $CONDA_BLD_PATH/linux-64/psi4-1.0rc147-py27_g8cc70ea.tar.bz2 .
conda install --yes conda conda-build
conda index

# <<<  Run Conda-Build on QC Set  >>>

    # recipe build #s should be incremented by here

cd $NIGHTLYDIR
conda list
pwd

conda build --override-channels \
    -c file://$MINIBUILDDIR/$CHANNEL \
    dftd3 \
    pcmsolver \
    chemps2 pychemps2 \
    psi4 \
    v2rdm_casscf

    #--skip-existing \

fi

#############
#  STAGE 2  #
#############

if [ $stage == "stage2" ]; then

# <<<  Prep  >>>

export PATH=$MINIBUILDDIR/minicondatoss/bin:$PATH
conda list

# <<<  Run Constructor of QC/Run  >>>

conda install --yes conda=4.0.9 constructor=1.2.0

    # items in $NIGHTLYDIR/installer/construct.yaml
    # - match above VERSION2 in "version" (usually VERSION == VERSION2)
    # - add psi4 to "channels"
    # - uncomment qc/run
    # - false "keep_pkgs"
    # - uncomment "post_install"

cd $NIGHTLYDIR
constructor installer
bash psi4conda-$VERSION2-Linux-x86_64.sh -b -p $MINIBUILDDIR/minicondatest-$VERSION2

scp -r psi4conda-$VERSION2-Linux-x86_64.sh psicode@www.psicode.org:~/html/downloads/psi4conda-$VERSION2-Linux-x86_64.sh

echo ssh psicode@www.psicode.org
echo cd html/downloads
echo ln -sf psi4conda-$VERSION2-Linux-x86_64.sh Psi4conda2-latest-Linux.sh

fi

exit 0




## <<<  PSICODE Feed  >>>
#
## Upon sucessful feed build, tars it up here and sends to psicode
##   uses double scp because single often fails, even command-line
#if [ -d "$CONDABUILDDIR/doc/sphinxman/feed" ]; then
#    cd $CONDABUILDDIR/doc/sphinxman
#    tar -zcf cb-feed.tar.gz feed/
#
#    scp -rv -o 'StrictHostKeyChecking no' cb-feed.tar.gz psicode@www.psicode.org:~/machinations/cb-feed.tar.gz
#    while [ $? -ne 0 ]; do
#        sleep 6
#        echo "trying to upload ghfeed"
#        scp -rv -o 'StrictHostKeyChecking no' cb-feed.tar.gz psicode@www.psicode.org:~/machinations/cb-feed.tar.gz
#    done
#fi

cd $NIGHTLYDIR
exit 0
