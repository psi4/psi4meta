mkdir build
cd build

if [ "$(uname)" == "Darwin" ]; then

    #HDF5_INTERJECT="-L${PREFIX}/lib;-lhdf5;-lhdf5_hl;-lhdf5;-lz;-ldl;-lm"
    HDF5_INTERJECT="-L${PREFIX}/lib;-lhdf5;-lhdf5_hl;-lhdf5;-lpthread;-lz;-ldl;-lm"
#/Users/loriab/anaconda/envs/_build/lib/libhdf5.dylib;/Users/loriab/anaconda/envs/_build/lib/libhdf5_hl.dylib;/Users/loriab/anaconda/envs/_build/lib/libhdf5.dylib;/Users/loriab/anaconda/envs/_build/lib/libz.dylib;/usr/lib/libdl.dylib;/usr/lib/libm.dylib

    # configure
    cmake \
        -DCMAKE_CXX_COMPILER="${PREFIX}/bin/g++" \
        -DCMAKE_C_COMPILER="${PREFIX}/bin/gcc" \
        -DEXTRA_C_FLAGS="''" \
        -DEXTRA_CXX_FLAGS="''" \
        -DSTATIC_ONLY=OFF \
        -DENABLE_GENERIC=OFF \
        -DMKL=OFF \
        -DBUILD_DOXYGEN=OFF \
        -DBUILD_SPHINX=OFF \
        -DENABLE_TESTS=OFF \
        -DHDF5_LIBRARIES="${HDF5_INTERJECT}" \
        -DHDF5_INCLUDE_DIRS="${PREFIX}/include" \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_INSTALL_LIBDIR=lib \
        ${SRC_DIR}

# try        -DSHARED_ONLY=ON \
#chemps2               -DENABLE_XHOST=ON

fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64

    # force static link to Intel mkl, except for openmp
    MKLROOT=/theoryfs2/common/software/intel2016/compilers_and_libraries_2016.2.181/linux/mkl/lib/intel64
    LAPACK_INTERJECT="-Wl,--start-group ${MKLROOT}/libmkl_cdft_core.a ${MKLROOT}/libmkl_intel_lp64.a ${MKLROOT}/libmkl_core.a ${MKLROOT}/libmkl_intel_thread.a ${MKLROOT}/libmkl_blacs_intelmpi_lp64.a -Wl,--end-group -lpthread -liomp5 -lm -ldl"

    # link against older libc for generic linux
    TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/nightly/glibc2.12
    LIBC_INTERJECT="-lrt -L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${PREFIX}/lib/libgcc_s.so ${TLIBC}/lib64/libc.so.6"

    # round off with pre-detected dependencies
    HDF5_INTERJECT="${PREFIX}/lib/libhdf5.so;${PREFIX}/lib/libhdf5_hl.so;${PREFIX}/lib/libhdf5.so;-lrt;-lz;-ldl;-lm"

    # configure
    ${PREFIX}/bin/cmake \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DEXTRA_C_FLAGS=" " \
        -DEXTRA_CXX_FLAGS=" " \
        -DSHARED_ONLY=ON \
        -DMKL=ON \
        -DBUILD_DOXYGEN=OFF \
        -DBUILD_SPHINX=OFF \
        -DENABLE_TESTS=OFF \
        -DENABLE_GENERIC=ON \
        -DENABLE_XHOST=OFF \
        -DLIBC_INTERJECT="${LIBC_INTERJECT}" \
        -DLAPACK_LIBRARIES="${LAPACK_INTERJECT}" \
        -DHDF5_LIBRARIES="${HDF5_INTERJECT}" \
        -DHDF5_INCLUDE_DIRS="${PREFIX}/include" \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_INSTALL_LIBDIR=lib \
        ${SRC_DIR}
fi

# build
make -j${CPU_COUNT}
#make VERBOSE=1

# install
make install

# test
# tests just segfault

