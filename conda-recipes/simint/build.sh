
#if [ "$(uname)" == "Darwin" ]; then
#
#    # configure
#    ${PREFIX}/bin/cmake \
#        -H${SRC_DIR} \
#        -Bbuild \
#        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
#        -DCMAKE_BUILD_TYPE=Release \
#        -DCMAKE_C_COMPILER="${PREFIX}/bin/gcc" \
#        -DCMAKE_Fortran_COMPILER="${PREFIX}/bin/gfortran" \
#        -DCMAKE_INSTALL_LIBDIR=lib \
#        -DBUILD_SHARED_LIBS=ON
#fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    set +x
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64
    set -x

    # link against older libc for generic linux
    TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/nightly/glibc2.12
    LIBC_INTERJECT="${TLIBC}/lib64/libc.so.6"

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DSIMINT_MAXAM=5 \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DBUILD_SHARED_LIBS=ON \
        -DSIMINT_VECTOR=sse \
        -DSIMINT_STANDALONE=ON \
        -DCMAKE_C_FLAGS="-qopenmp -static-libgcc -static-intel -wd10237" \
        -DLIBC_INTERJECT=${LIBC_INTERJECT} \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -DENABLE_TESTS=OFF
        # OpenMP always ON
        # SIMINT_VECTOR=sse == DENABLE_XHOST=OFF
fi

# build
cd build
make -j${CPU_COUNT}
#make VERBOSE=1

# install
make install

# test
# no independent tests

