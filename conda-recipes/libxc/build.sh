
if [ "$(uname)" == "Darwin" ]; then

    # TOGGLE: intel for psi4
    # Intel atop conda Clang
    #CMAKE_C_FLAGS="${CFLAGS} -clang-name=${CLANG} -msse4.1 -axCORE-AVX2"
    #-DCMAKE_C_COMPILER=icc \

    CMAKE_C_FLAGS="${CFLAGS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=${CC} \
        -DCMAKE_C_FLAGS="${CMAKE_C_FLAGS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DNAMESPACE_INSTALL_INCLUDEDIR="/" \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_XHOST=OFF \
        -DBUILD_TESTING=ON
fi


if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    source /theoryfs2/common/software/intel2021/oneapi/setvars.sh --config="/theoryfs2/common/software/intel2021/oneapi/config-no-intelpython.txt" intel64

    # link against conda MKL & GCC
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_C_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DNAMESPACE_INSTALL_INCLUDEDIR="/" \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=OFF \
        -DBUILD_TESTING=ON
fi

# build
cd build
make -j${CPU_COUNT}

# install
make install

# test
#make test

# Notes
#    source /theoryfs2/common/software/intel2018/bin/compilervars.sh intel64
