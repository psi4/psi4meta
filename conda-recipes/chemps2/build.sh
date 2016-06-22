mkdir build
cd build

if [ "$(uname)" == "Darwin" ]; then

    #HDF5_INTERJECT="-L${PREFIX}/lib;-lhdf5;-lhdf5_hl;-lhdf5;-lz;-ldl;-lm"
    HDF5_INTERJECT="-L${PREFIX}/lib;-lhdf5;-lhdf5_hl;-lhdf5;-lpthread;-lz;-ldl;-lm"
#/Users/loriab/anaconda/envs/_build/lib/libhdf5.dylib;/Users/loriab/anaconda/envs/_build/lib/libhdf5_hl.dylib;/Users/loriab/anaconda/envs/_build/lib/libhdf5.dylib;/Users/loriab/anaconda/envs/_build/lib/libz.dylib;/usr/lib/libdl.dylib;/usr/lib/libm.dylib

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

#chemps2               -DENABLE_XHOST=ON

fi

if [ "$(uname)" == "Linux" ]; then


    # load Intel compilers and mkl
    source /theoryfs2/common/software/intel2015/bin/compilervars.sh intel64
    # force static link to Intel mkl, except for openmp
    MKLROOT=/theoryfs2/common/software/intel2015/composer_xe_2015.3.187/mkl/lib/intel64
    LAPACK_INTERJECT="${MKLROOT}/libmkl_intel_lp64.a ${MKLROOT}/libmkl_intel_thread.a ${MKLROOT}/libmkl_core.a -liomp5 -lm"
    # link against older libc for generic linux
    TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/psi4cmake/psi4/glibc2.12rpm
    LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6"
    # round off with pre-detected dependencies
    MCONDA=${PREFIX}/lib
    GSL_INTERJECT="-L${MCONDA};-lhdf5;-lhdf5_hl;-lhdf5;-lpthread;-lz;-lrt;-ldl;-lm"
    HDF5_INTERJECT="-L${MCONDA};-lgsl;-lgslcblas;-lm"
    
    cmake \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_C_COMPILER=icc \
        -DEXTRA_C_FLAGS=" " \
        -DEXTRA_CXX_FLAGS=" " \
        -DMKL=ON \
        -DBUILD_DOXYGEN=OFF \
        -DBUILD_SPHINX=OFF \
        -DENABLE_TESTS=OFF \
        -DENABLE_GENERIC=ON \
        -DENABLE_XHOST=OFF \
        -DLAPACK_LIBRARIES="${LIBC_INTERJECT} ${LAPACK_INTERJECT}" \
        -DHDF5_LIBRARIES="${HDF5_INTERJECT}" \
        -DHDF5_INCLUDE_DIRS="${MCONDA}/../include" \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_INSTALL_LIBDIR=lib \
        ${SRC_DIR}
fi

make -j${CPU_COUNT}
make install

#cd ../PyCheMPS2
#export CPATH=${CPATH}:${PREFIX}/include
#${PYTHON} setup.py build_ext -L ${PREFIX}/lib
#${PYTHON} setup.py install --prefix=${PREFIX}


#    -DLIBC_INTERJECT="${LIBC_INTERJECT}" \
#    -DLAPACK_LIBRARIES="${LAPACK_INTERJECT}" \

