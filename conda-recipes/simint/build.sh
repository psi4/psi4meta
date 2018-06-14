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
        -DSIMINT_MAXAM=7 \
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
# * Note that this test won't pass/fail; you have to look at it.
# * On Mac, running the test takes hours with no output, so skipping (could use a smaller test)
if [ "$(uname)" == "Darwin" ]; then
    #OMP_NUM_THREADS=${CPU_COUNT} test/test_eri ../test/dat/ethane.dzp.mol
elif [ "$(uname)" == "Linux" ]; then
    LD_LIBRARY_PATH=${BUILD_PREFIX}/lib:${LD_LIBRARY_PATH} OMP_NUM_THREADS=${CPU_COUNT} test/test_eri ../test/dat/ethane.dzp.mol
fi
