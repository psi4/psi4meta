
if [ "$(uname)" == "Darwin" ]; then

    export DYLD_LIBRARY_PATH=${PREFIX}/lib:${DYLD_LIBRARY_PATH}

    make
    # pseudo "make install"
    mkdir -p ${PREFIX}/bin
    cp dftd3 ${PREFIX}/bin
else

    # load Intel compilers and mkl
    source /theoryfs2/common/software/intel2015/bin/compilervars.sh intel64

fi


