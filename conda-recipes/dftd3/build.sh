
if [ "$(uname)" == "Darwin" ]; then

    echo ''

else

    # load Intel compilers and mkl
    source /theoryfs2/common/software/intel2015/bin/compilervars.sh intel64

fi

make
# pseudo "make install"
mkdir -p ${PREFIX}/bin
cp dftd3 ${PREFIX}/bin

