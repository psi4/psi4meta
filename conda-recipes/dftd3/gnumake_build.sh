
if [ "$(uname)" == "Darwin" ]; then

    make FC='${GFORTRAN}' LINKER='${GFORTRAN}'
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2018/bin/compilervars.sh intel64
    set -x

    make FC='ifort' LINKER='ifort -static'
fi

# pseudo "make install"
mkdir -p ${PREFIX}/bin
cp dftd3 ${PREFIX}/bin

