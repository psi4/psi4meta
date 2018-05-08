if [ "${PSI_BUILD_ISA}" == "sse41" ]; then
    ISA="-msse4.1"
elif [ "${PSI_BUILD_ISA}" == "avx2" ]; then
    ISA="-march=native"
fi


if [ "$(uname)" == "Darwin" ]; then

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_C_FLAGS="${ISA}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_OPENMP=OFF \
        -DFRAGLIB_UNDERSCORE_L=OFF \
        -DFRAGLIB_DEEP=OFF \
        -DINSTALL_DEVEL_HEADERS=ON \
        -DLAPACK_LIBRARIES="${PREFIX}/lib/libmkl_rt.dylib"
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    set +x
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64
    set -x

    # force static link to Intel mkl, except for openmp
    #MKLROOT=/theoryfs2/common/software/intel2016/compilers_and_libraries_2016.2.181/linux/mkl/lib/intel64
    #LAPACK_INTERJECT="${MKLROOT}/libmkl_lapack95_lp64.a;-Wl,--start-group;${MKLROOT}/libmkl_intel_lp64.a;${MKLROOT}/libmkl_sequential.a;${MKLROOT}/libmkl_core.a;-Wl,--end-group;-lpthread;-lm;-ldl"
    LAPACK_INTERJECT="${PREFIX}/lib/libmkl_rt.so"

    # link against older libc for generic linux
    TLIBC=/home/psilocaluser/installs/glibc2.12
    LIBC_INTERJECT="${TLIBC}/lib64/libc.so.6"

    # build multi-instruction-set library
    OPTS="-msse2 -axCORE-AVX2,AVX"

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_C_FLAGS="${OPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_OPENMP=OFF \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON \
        -DFRAGLIB_UNDERSCORE_L=OFF \
        -DFRAGLIB_DEEP=OFF \
        -DINSTALL_DEVEL_HEADERS=ON \
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
# Note: gcc4.8.5 just fine; using 5.2 for consistency.
