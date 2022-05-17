
if [ "$(uname)" == "Darwin" ]; then

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=${CLANG} \
        -DCMAKE_CXX_COMPILER=${CLANGXX} \
        -DCMAKE_C_FLAGS="${CFLAGS} ${OPTS}" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS} ${OPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DNAMESPACE_INSTALL_INCLUDEDIR="/" \
        -DBUILD_SHARED_LIBS=ON \
        -DLIBECPINT_USE_PUGIXML=OFF \
        -DLIBECPINT_BUILD_TESTS=OFF \
        -DLIBECPINT_BUILD_DOCS=OFF \
        -DLIBECPINT_MAX_UNROL=1 \
        -DLIBECPINT_MAX_L=5 \
        -DCMAKE_OSX_DEPLOYMENT_TARGET=''
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
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DNAMESPACE_INSTALL_INCLUDEDIR="/" \
        -DBUILD_SHARED_LIBS=ON \
        -DLIBECPINT_USE_PUGIXML=OFF \
        -DLIBECPINT_BUILD_TESTS=OFF \
        -DLIBECPINT_BUILD_DOCS=OFF \
        -DLIBECPINT_MAX_UNROL=1 \
        -DLIBECPINT_MAX_L=5
fi

# build & install
cmake --build build --target install #-j${CPU_COUNT}

# test
#make test

# Notes

