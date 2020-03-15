
if [ "$(uname)" == "Darwin" ]; then

    make FC='${GFORTRAN}' LINKER='${GFORTRAN}'

    # pseudo "make install"
    mkdir -p ${PREFIX}/bin
    cp gcp ${PREFIX}/bin
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2018/bin/compilervars.sh intel64
    set -x

    make FC='ifort' LINKER='ifort'


    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2018/bin/compilervars.sh intel64
    set -x

    # link against conda GCC
    ALLOPTS="-O3 -gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_Fortran_COMPILER=ifort \
        -DCMAKE_Fortran_FLAGS="${ALLOPTS}" \
        -DENABLE_XHOST=OFF

    # build
    cd build
    make -j${CPU_COUNT}

    # install
    make install

    # test
    # no independent tests
fi

# History

#    make FC='ifort' LINKER='ifort -static'

