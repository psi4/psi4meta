
if [ "$(uname)" == "Darwin" ]; then

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_OPENMP=OFF \
        -DFRAGLIB_UNDERSCORE_L=OFF \
        -DFRAGLIB_DEEP=OFF
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64

    # force static link to Intel mkl, except for openmp
    MKLROOT=/theoryfs2/common/software/intel2016/compilers_and_libraries_2016.2.181/linux/mkl/lib/intel64
    LAPACK_INTERJECT="${MKLROOT}/libmkl_lapack95_lp64.a;-Wl,--start-group;${MKLROOT}/libmkl_intel_lp64.a;${MKLROOT}/libmkl_sequential.a;${MKLROOT}/libmkl_core.a;-Wl,--end-group;-lpthread;-lm;-ldl"

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
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_OPENMP=OFF \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON \
        -DFRAGLIB_UNDERSCORE_L=OFF \
        -DFRAGLIB_DEEP=OFF \
        -DLIBC_INTERJECT="${LIBC_INTERJECT}" \
        -DLAPACK_LIBRARIES=${LAPACK_INTERJECT}
fi

# build
cd build
make -j${CPU_COUNT}
#make VERBOSE=1

# install
make install

# test
# no independent library tests

# Note: add -DCMAKE_C_FLAGS="-liomp5" for static link w/o mkl
