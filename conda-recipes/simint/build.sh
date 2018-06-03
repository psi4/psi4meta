if [ "$(uname)" == "Darwin" ]; then

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=${CLANG} \
        -DCMAKE_CXX_COMPILER=${CLANGXX} \
        -DCMAKE_C_FLAGS="${CFLAGS}" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -DSIMINT_MAXAM=${MAX_AM_ERI} \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DBUILD_SHARED_LIBS=ON \
        -DSIMINT_VECTOR="${SIMINT_VECTOR}" \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -DENABLE_TESTS=OFF
fi

# build
cd build
make -j${CPU_COUNT}

# install
make install

# test
# turned off to avoid CXX
