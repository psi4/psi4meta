#!/bin/bash

# [LAB, 28 Jun 2016]
# execute as >>> bash -x -e kitandkaboodle.sh args

if [ $# -ne 1 ]; then
    echo $0: usage: kitandkaboodle.sh stage1     # setup from scratch
    echo $0: usage: kitandkaboodle.sh stage12    # setup from scratch and build all
    echo $0: usage: kitandkaboodle.sh stage2psi  # build psi4 only
    echo $0: usage: kitandkaboodle.sh stage3     # package up installer
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

VERSION=0.9.8
CHANNEL="localchannel-$VERSION"
VERSION3=0.9.9


#############
#  STAGE 1  #
#############

# * set VERSION above
# * clear PIN-TO-BUILD in recipes
# * prepare items in $NIGHTLYDIR/installer/construct.yaml
#   - increment and match above VERSION in "version"
#   - free only in "channels"
#   - uncomment build/run
#   - true "keep_pkgs"
#   - comment "post_install"

if [[ $stage == "stage1" || $stage == "stage12" ]]; then

# <<<  Prepare Throwaway Conda Installation w/ Driver  >>>

cd $MINIBUILDDIR
bash $MINIINSTALLER -b -p $MINIBUILDDIR/minicondadrive
export PATH=$MINIBUILDDIR/minicondadrive/bin:$PATH
conda update --yes --all
    # install packages from installer/construct.yaml "driver" section
conda install --yes conda conda-build constructor anaconda-client
conda list

# <<<  Run Constructor of Build/Run  >>>

conda install --yes conda=4.0.9 constructor=1.2.0

cd $NIGHTLYDIR
constructor installer
bash psi4conda-$VERSION-Linux-x86_64.sh -b -p $MINIBUILDDIR/minicondastore-$VERSION
cd $MINIBUILDDIR
mkdir -p "$CHANNEL/linux-64"
cd "$CHANNEL/linux-64"
ln -s $MINIBUILDDIR/minicondastore-$VERSION/pkgs/*bz2 .
conda index

fi

#############
#  STAGE 2  #
#############

# * check VERSION above is the pkg repo want recipes built from
# * set PIN-TO-BUILD in recipes (e.g., hdf5 and chemps2) to detected one from stage 1
# * installer/construct.yaml irrelevant
# * leave the ordering, but can choose the built packages
# * increment recipe build numbers if want to upload

if [[ $stage == "stage2" || $stage == "stage12" ]]; then

# <<<  Prep  >>>

export PATH=$MINIBUILDDIR/minicondadrive/bin:$PATH

# <<<  Run Conda-Build on QC Set  >>>

conda install --yes conda conda-build
conda list

cd $NIGHTLYDIR
conda build --override-channels \
    -c file://$MINIBUILDDIR/$CHANNEL \
    dftd3 \
    pcmsolver \
    chemps2 pychemps2 \
    psi4 \
    v2rdm_casscf

fi

################
#  STAGE 2PSI  #
################

if [ $stage == "stage2psi" ]; then

# <<<  Prep  >>>

export PATH=$MINIBUILDDIR/minicondadrive/bin:$PATH
CONDABUILDDIR=$CONDA_BLD_PATH/work/build

# <<<  Run Conda-Build on QC Set  >>>

conda install --yes conda conda-build
conda list

cd $NIGHTLYDIR
conda build --override-channels \
    -c file://$MINIBUILDDIR/$CHANNEL \
    psi4

# <<<  Docs Feed  >>>

# Upon sucessful docs build, tars it up here and sends to psicode
#   uses double scp because single often fails, even command-line
# The godaddy site keeps changing identities so circumventing check
if [ -d "$CONDABUILDDIR/doc/sphinxman/html" ]; then
    cd $CONDABUILDDIR/doc/sphinxman
    mv html master
    tar -zcf cb-sphinxman.tar.gz master/

    scp -rv -o 'StrictHostKeyChecking no' cb-sphinxman.tar.gz psicode@www.psicode.org:~/machinations/cb-sphinxman.tar.gz
    while [ $? -ne 0 ]; do
        sleep 6
        echo "trying to upload sphinxman"
        scp -rv -o 'StrictHostKeyChecking no' cb-sphinxman.tar.gz psicode@www.psicode.org:~/machinations/cb-sphinxman.tar.gz
    done
fi

# <<<  PSICODE Feed  >>>

# Upon sucessful feed build, tars it up here and sends to psicode
#   uses double scp because single often fails, even command-line
if [ -d "$CONDABUILDDIR/doc/sphinxman/feed" ]; then
    cd $CONDABUILDDIR/doc/sphinxman
    tar -zcf cb-feed.tar.gz feed/

    scp -rv -o 'StrictHostKeyChecking no' cb-feed.tar.gz psicode@www.psicode.org:~/machinations/cb-feed.tar.gz
    while [ $? -ne 0 ]; do
        sleep 6
        echo "trying to upload ghfeed"
        scp -rv -o 'StrictHostKeyChecking no' cb-feed.tar.gz psicode@www.psicode.org:~/machinations/cb-feed.tar.gz
    done
fi

fi

#############
#  STAGE 3  #
#############

# * set VERSION3 above to installer desired version (usually VERSION == VERSION3)
# * items in $NIGHTLYDIR/installer/construct.yaml
#   - match above VERSION3 in "version"
#   - add psi4 to "channels"
#   - uncomment qc/run
#   - false "keep_pkgs"
#   - uncomment "post_install"

if [ $stage == "stage3" ]; then

# <<<  Prep  >>>

export PATH=$MINIBUILDDIR/minicondadrive/bin:$PATH

# <<<  Run Constructor of QC/Run  >>>

conda install --yes conda=4.0.9 constructor=1.2.0
conda list


cd $NIGHTLYDIR
constructor installer
bash psi4conda-$VERSION3-Linux-x86_64.sh -b -p $MINIBUILDDIR/minicondatest-$VERSION3

scp -r psi4conda-$VERSION3-Linux-x86_64.sh psicode@www.psicode.org:~/html/downloads/psi4conda-$VERSION3-Linux-x86_64.sh

set +x
echo TODO:
echo ssh psicode@www.psicode.org
echo cd html/downloads && ln -sf psi4conda-$VERSION3-Linux-x86_64.sh Psi4conda2-latest-Linux.sh
echo * Add versions to download page pill buttons

fi

cd $NIGHTLYDIR
exit 0
