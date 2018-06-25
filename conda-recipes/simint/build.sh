
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


if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    # * NOTE 2017.0.4 --- 2018 makes bad library!
    set +x
    source /theoryfs2/common/software/intel2017/bin/compilervars.sh intel64
    set -x

    # link against conda GCC
    # * NOTE no OPTS, as arch handled internally
    ALLOPTS="-gnu-prefix=${HOST}-"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_C_FLAGS="${ALLOPTS}" \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DSIMINT_MAXAM=7 \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DBUILD_SHARED_LIBS=ON \
        -DSIMINT_VECTOR="${SIMINT_VECTOR}" \
        -DSIMINT_STANDALONE=ON \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -DENABLE_TESTS=ON

        # OpenMP always ON
        # SIMINT_VECTOR=sse == DENABLE_XHOST=OFF
        #-DCMAKE_C_FLAGS="-qopenmp -static-libgcc -static-intel -wd10237" \
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
