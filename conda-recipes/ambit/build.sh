if [ "$(uname)" == "Darwin" ]; then

    # conda gnu compilers
    CXX="${PREFIX}/bin/g++"
    CC="${PREFIX}/bin/gcc"
    F90="${PREFIX}/bin/gfortran"
    HDF5_INTERJECT="-L${PREFIX}/lib;-lhdf5;-lhdf5_hl;-lhdf5;-lpthread;-lz;-ldl;-lm"

    mkdir build
    cd build
    cmake \
        -DCMAKE_C_COMPILER=${CC} \
        -DCMAKE_CXX_COMPILER=${CXX} \
        -DCMAKE_Fortran_COMPILER=${F90} \
        -DPYTHON_INTERPRETER=${PYTHON} \
        -DENABLE_MPI=OFF \
        -DENABLE_OMP=ON \
        -DENABLE_VECTORIZATION=OFF \
        -DENABLE_THREADED_MKL=OFF \
        -DBOOST_INCLUDEDIR="${PREFIX}/include" \
        -DBOOST_LIBRARYDIR="${PREFIX}/lib" \
        -DHDF5_INCLUDE_DIRS="${PREFIX}/include" \
        -DHDF5_LIBRARIES="${HDF5_INTERJECT}" \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DCMAKE_BUILD_TYPE=release \
        ${SRC_DIR}
    make -j${CPU_COUNT}
    make install

    # test
    rm ${PREFIX}/lib/libsqlite3*
    export DYLD_LIBRARY_PATH="${PREFIX}/lib/:$DYLD_LIBRARY_PATH"
    ctest

        #-DENABLE_GENERIC=ON \
        #-DENABLE_XHOST=OFF \
        #-DENABLE_STATIC_LINKING=ON \
fi

if [ "$(uname)" == "Linux" ]; then
    # load Intel compilers and mkl
    source /theoryfs2/common/software/intel2015/bin/compilervars.sh intel64
    # force static link to Intel mkl, except for openmp
    MKLROOT=/theoryfs2/common/software/intel2015/composer_xe_2015.3.187/mkl/lib/intel64
    LAPACK_INTERJECT="${MKLROOT}/libmkl_intel_lp64.a ${MKLROOT}/libmkl_intel_thread.a ${MKLROOT}/libmkl_core.a -liomp5 -lm"
    
    
    #-Wl,--start-group -Wl,-Bstatic -lmkl_lapack95_lp64 -Wl,-Bdynamic -lmkl_intel_lp64 -openmp -Wl,--end-group -Wl,--start-group -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -lpthread /theoryfs2/ds/cdsgroup/miniconda/lib/libm.so -openmp -Wl,--end-group
    
    
    # link against older libc for generic linux
    TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/psi4cmake/psi4/glibc2.12rpm
    LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6"
    # round off with pre-detected dependencies
    MCONDA=${PREFIX}/lib
    HDF5_INTERJECT="-L${MCONDA};-lhdf5;-lhdf5_hl;-lhdf5;-lpthread;-lz;-lrt;-ldl;-lm"
    
    mkdir build
    cd build
    cmake \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_Fortran_COMPILER=ifort \
        -DPYTHON_INTERPRETER=${PYTHON} \
        -DENABLE_MPI=OFF \
        -DENABLE_OMP=ON \
        -DENABLE_GENERIC=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_STATIC_LINKING=ON \
        -DENABLE_VECTORIZATION=OFF \
        -DENABLE_THREADED_MKL=OFF \
        -DBOOST_INCLUDEDIR=/theoryfs2/ds/cdsgroup/psi4-compile/psi4pubfork/psi4/objdir-boost/boost/include \
        -DBOOST_LIBRARYDIR=/theoryfs2/ds/cdsgroup/psi4-compile/psi4pubfork/psi4/objdir-boost/boost/lib/ \
        -DHDF5_LIBRARIES="${HDF5_INTERJECT}" \
        -DHDF5_INCLUDE_DIRS="${MCONDA}/../include" \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DCMAKE_BUILD_TYPE=release \
        ${SRC_DIR}
    make -j${CPU_COUNT} VERBOSE=1
    make install
    
    #    -DDETECT_EXTERNAL_STATIC=ON \
    #    -DENABLE_STATIC=ON \
    #    -DLAPACK_LIBRARIES="${LIBC_INTERJECT} ${LAPACK_INTERJECT}" \
    #NLIBC=""
    #LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TTLIBC}/lib64/libgcc_s.so.1 ${TLIBC}/lib64/libc.so.6 ${TTLIBC}/lib64/libgcc_s.so.1"
    #LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6 ${NLIBC}/lib64/libgcc_s.so.1 ${TLIBC}/lib64/libc.so.6"
    #make -j${CPU_COUNT} VERBOSE=1
    
    #   list(APPEND AmbitCMakeArgs
    #            -DENABLE_VECTORIZATION=${Ambit_VECTORIZATION}
    #            -DENABLE_PSI4=ON
    #            -DPSI4_SOURCE_DIR=${PROJECT_SOURCE_DIR}
    #            -DPSI4_BINARY_DIR=${PROJECT_BINARY_DIR}
    #            -DPSI4_INCLUDE_DIRS=${PYTHON_INCLUDE_DIR}
    #
    #    -DENABLE_STATIC_LINKING=ON \
    #    -DDETECT_EXTERNAL_STATIC=ON \
    #    -DENABLE_CONDA_DEST=ON \
    #    -DLIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6" \
    
    
    #//Value Computed by CMake
    #psi4_BINARY_DIR:STATIC=/theoryfs2/ds/cdsgroup/psi4-compile/psi4pubfork/psi4/objdir-nupkg2
    #
    #//Value Computed by CMake
    #psi4_SOURCE_DIR:STATIC=/theoryfs2/ds/cdsgroup/psi4-compile/psi4pubfork/psi4
    #
    #//Dependencies for the target
    #psi4util_LIB_DEPENDS:STATIC=general;/usr/lib64/libutil.so;general;/usr/lib64/libm.so;general;/usr/lib64/librt.so;general;/usr/lib64/libdl.so;general;;general;/theoryfs2/ds/cdsgroup/miniconda/envs/p4buildenv/lib/libpython2.7.so;
#

fi
