#!/bin/bash

# [LAB, 8 Mar 2015]
# Changed arguments of CTest line and now connects to CDash
# [LAB, 7 Mar 2015]
# Works through build and test. Not connecting to CDash
# [LAB, 9 Mar 2015]
# Works, including connection to CDash. Run in crontab as
# 00 02 * * * /theoryfs2/ds/cdsgroup/psi4-compile/nightly/nightlycondabuildctestcdash.sh > /theoryfs2/ds/cdsgroup/psi4-compile/nightly/cb.log
# [LAB, 22 May 2015]
# crontab line above moved from ds2 to psinet and NPROC adjusted accordingly
# arranged CONDA_BLD_PATH so that builds in scratch
# [LAB, 29 May 2015]
# work on docs build and packing
# [LAB, 2 Jun 2015]
# get scp to psicode working
# [LAB, 22 Jun 2015]
# get feed scp to psicode working, erroring a lot upon connection
# [LAB, 20 Jul 2015]
# split out mrcc test cases so can give them the Intel compilers the exe needs
# [LAB, 22 Jul 2015]
# add loop to get around psicode failures: ssh_exchange_identification: Connection closed by remote host
# [LAB, 23 Jan 2016]
# switch out to new miniconda install. now working from ~/miniconda/bin, instead of ~/psi4-install/miniconda/bin
# [LAB, 24 Jan 2016]
# add no host checking to get around psicode failures: DSA host key for www.psicode.org has changed and you have requested strict checking.
# [LAB, 8 Mar 2016]
# fake the pcmsolver link to make those test cases pass
# [LAB, 12 Mar 2016]
# can't do ctest -LE multiple times so awkward regex instead to catch pcmsolver & dmrcc

# Make a restricted path and ld_library_path that includes conda's cmake
#   (3.1) and python (2.7). This forcible inclusion of conda's python in the
#   latter variable (now set just before testing) is because the nice linking
#   arrangments conda provides are for the *installed* entity whereas the ctest
#   facilities needed for a CDash submission are present in the *build* entity.
#export PATH=/theoryfs2/ds/cdsgroup/psi4-install/miniconda/bin:/theoryfs2/ds/cdsgroup/psi4-install/miniconda/envs/p4env/bin:/theoryfs2/ds/cdsgroup/psi4-compile/mrcc:/theoryfs2/ds/cdsgroup/scripts/bin:/theoryfs2/common/software/libexec/git-core:/usr/lib64/qt-3.3/bin:/theoryfs2/ds/cdsgroup/perl5/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin
export PATH=/theoryfs2/ds/cdsgroup/miniconda/bin:/theoryfs2/ds/cdsgroup/psi4-compile/mrcc:/theoryfs2/ds/cdsgroup/scripts/bin:/theoryfs2/common/software/libexec/git-core:/usr/lib64/qt-3.3/bin:/theoryfs2/ds/cdsgroup/perl5/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin
#export LD_LIBRARY_PATH=/theoryfs2/ds/cdsgroup/psi4-install/miniconda/envs/p4env/lib
#export LD_LIBRARY_PATH=/theoryfs2/ds/cdsgroup/psi4-install/miniconda/lib
source /theoryfs2/common/software/intel2015/bin/compilervars.sh intel64
export PYTHONIOENCODING="UTF-8"  # fix for temp bug https://github.com/conda/conda-build/issues/636
#newconda export LD_LIBRARY_PATH=/theoryfs2/ds/cdsgroup/psi4-install/miniconda/envs/analibgcc/lib:$LD_LIBRARY_PATH

# CDash tag according to RDR pattern
TAG=LAB-intel15.0-mkl-release-conda

# Directory containing this script itself. Moreover, contains a directory
#   psi4 containing the conda-build recipe files meta.yaml and build.sh
NIGHTLYDIR=/theoryfs2/ds/cdsgroup/psi4-compile/psi4meta/conda-recipes

# Machine settings and directories
#   if CONDA_BLD_PATH not set, takes value of $MINICONDA/conda-bld
#   * $CONDA_BLD_PATH/work is equiv to the head psi4 directory in a psi4 repo
#   * $CONDA_BLD_PATH/work/build is equiv to objdir in which code is built
#   * $MINICONDA/envs/_build_placehold_placehold_pl is equiv to --prefix directory in which code is installed
export NPROCS=4
export CTEST_MAKE_NUM_PROCS=$NPROCS
export PSI_SCRATCH=/scratch/cdsgroup
export CONDA_BLD_PATH=/scratch/cdsgroup/conda-builds
MINICONDA=/theoryfs2/ds/cdsgroup/miniconda
CONDABUILDDIR=$CONDA_BLD_PATH/work/build
CONDAINSTALLDIR=$MINICONDA/envs/_build_placehold_placehold_placehold_place

# <<<  Build Conda Binary  >>>

# This script moves to a directory $NIGHTLYDIR that contains the
#   psi4 conda recipe that is essentially the same as in the psi4
#   repository (can't use the psi4/conda-recipes/psi4 code itself b/c
#   the recipe is cloning the repo from github). It issues conda-build
#   which checks out the source from github (ssh key, private repo)
#   into $MINICONDA/conda-bld/work (directory gets entirely replaced at 
#   every invocation of conda-build) and proceeds to build it according
#   to cmake directions in $NIGHTLYDIR/psi4/build.sh, install it into
#   $CONDAINSTALLDIR. When this completes successfully, it zips up the 
#   conda package and automatically uploads it to binstar because of the 
#   following line in ~/.condarc:
#       binstar_upload: yes
cd $NIGHTLYDIR
conda build psi4
#binstar upload /path/to/conda-package-2.0.tar.bz2 --channel test
#binstar channel --copy test main

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

# <<<  Dashboard Tests  >>>

# Form links to enable misuse of conda (conda wants to run from installed pkg, 
#   ctest wants git repo)
mkdir -p $CONDAINSTALLDIR/bin
ln -s $MINICONDA/bin/python $CONDAINSTALLDIR/bin/python

# Runs test cases and hopefully communicates results with CDash.
#   Communication details in psi4/CTestConfig.cmake in repo.
#   Intel sourced b/c mrcc depends on it, not psi4
#   Installed conda package gets the pcmsolver substitution right,
#   but testdir doesn't, hence the sed.
#   -LE command excludes pcmsolver and dmrcc categories
cd $CONDABUILDDIR
export LD_LIBRARY_PATH=$CONDAINSTALLDIR/share
ctest -M Nightly -T Test -T Submit -LE ^[pd][mc][rm][cs] -j$NPROCS
source /theoryfs2/common/software/intel2015/bin/compilervars.sh intel64
ctest -M Nightly -T Test -T Submit -L dmrcc -j$NPROCS
sed -i "s|/opt/anaconda1anaconda2anaconda3|$CONDAINSTALLDIR|g" $CONDAINSTALLDIR/share/psi4/python/pcm_placeholder.py
export PYTHONPATH=$CONDAINSTALLDIR/bin:$PYTHONPATH
ctest -M Nightly -T Test -T Submit -L pcmsolver -j$NPROCS

cd $NIGHTLYDIR
exit 0
