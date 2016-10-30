mkdir build
cd build

if [ "$(uname)" == "Darwin" ]; then

    #HDF5_INTERJECT="-L${PREFIX}/lib;-lhdf5;-lhdf5_hl;-lhdf5;-lz;-ldl;-lm"
    HDF5_INTERJECT="-L${PREFIX}/lib;-lhdf5;-lhdf5_hl;-lhdf5;-lpthread;-lz;-ldl;-lm"
#/Users/loriab/anaconda/envs/_build/lib/libhdf5.dylib;/Users/loriab/anaconda/envs/_build/lib/libhdf5_hl.dylib;/Users/loriab/anaconda/envs/_build/lib/libhdf5.dylib;/Users/loriab/anaconda/envs/_build/lib/libz.dylib;/usr/lib/libdl.dylib;/usr/lib/libm.dylib

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER="${PREFIX}/bin/gcc" \
        -DCMAKE_CXX_COMPILER="${PREFIX}/bin/g++" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DSHARED_ONLY=ON \
        -DENABLE_OPENMP=ON \
        -DMKL=OFF \
        -DBUILD_DOXYGEN=OFF \
        -DBUILD_SPHINX=OFF \
        -DENABLE_TESTS=OFF \
        -DHDF5_LIBRARIES="${HDF5_INTERJECT}" \
        -DHDF5_INCLUDE_DIRS="${PREFIX}/include"

#chemps2               -DENABLE_XHOST=ON


#           CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/external/chemps2
#                       -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
#                       -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
#                       -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
#                       -DCMAKE_INSTALL_LIBDIR=${CMAKE_INSTALL_LIBDIR}
#?                       -DSTATIC_ONLY=${_a_only}
#                       -DSHARED_ONLY=${_so_only}
#                       -DENABLE_OPENMP=${ENABLE_OPENMP}  # relevant
#                       -DENABLE_XHOST=${ENABLE_XHOST}
#?                       -DBUILD_FPIC=${BUILD_FPIC}
#                       -DENABLE_GENERIC=${ENABLE_GENERIC}
#?                       -DCMAKE_RANLIB=${CMAKE_RANLIB}
#?                       -DCMAKE_AR=${CMAKE_AR}
#?                       -DCMAKE_NM=${CMAKE_NM}
#?                       -DENABLE_TESTS=OFF
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

# linux not retested
    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DSHARED_ONLY=ON \
        -DENABLE_OPENMP=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON \
        -DMKL=ON \
        -DBUILD_DOXYGEN=OFF \
        -DBUILD_SPHINX=OFF \
        -DENABLE_TESTS=ON \
        -DLIBC_INTERJECT="${LIBC_INTERJECT}" \
        -DLAPACK_LIBRARIES="${LAPACK_INTERJECT}" \
        -DHDF5_LIBRARIES="${HDF5_INTERJECT}" \
        -DHDF5_INCLUDE_DIRS="${PREFIX}/include"
fi

# build
cd build
make -j${CPU_COUNT}
#make VERBOSE=1

# install
make install

# test
# tests just segfault
make test
# tests segfault on mac
