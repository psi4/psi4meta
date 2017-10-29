if [ "${PSI_BUILD_ISA}" == "sse41" ]; then
    ISA="-msse4.1"
elif [ "${PSI_BUILD_ISA}" == "avx2" ]; then
    ISA="-march=native"
fi


if [ "$(uname)" == "Darwin" ]; then

    if [ "${PSI_BUILD_CCFAM}" == "gnu" ]; then
        CC="${PREFIX}/bin/gcc"
        CXX="${PREFIX}/bin/g++"
        CCFLAGS=""
        CXXFLAGS=""
    else
        CC="clang"
        CXX="clang++"
        CCFLAGS=""
        CXXFLAGS="-stdlib=libc++ "
    fi

    LAPACK_INTERJECT="${PREFIX}/lib/libmkl_rt.dylib;${PREFIX}/lib/libiomp5.dylib"
    #HDF5_INTERJECT="-L${PREFIX}/lib;-lhdf5;-lhdf5_hl;-lhdf5;-lz;-ldl;-lm"
    HDF5_INTERJECT="-L${PREFIX}/lib;-lhdf5;-lhdf5_hl;-lhdf5;-lpthread;-lz;-ldl;-lm"
#/Users/loriab/anaconda/envs/_build/lib/libhdf5.dylib;/Users/loriab/anaconda/envs/_build/lib/libhdf5_hl.dylib;/Users/loriab/anaconda/envs/_build/lib/libhdf5.dylib;/Users/loriab/anaconda/envs/_build/lib/libz.dylib;/usr/lib/libdl.dylib;/usr/lib/libm.dylib

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER="${CC}" \
        -DCMAKE_C_FLAGS="${CCFLAGS}${ISA}" \
        -DCMAKE_CXX_COMPILER="${CXX}" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}${ISA}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DSHARED_ONLY=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_OPENMP=ON \
        -DMKL=OFF \
        -DBUILD_DOXYGEN=OFF \
        -DBUILD_SPHINX=OFF \
        -DENABLE_TESTS=OFF \
        -DLAPACK_LIBRARIES=${LAPACK_INTERJECT} \
        -DHDF5_LIBRARIES="${HDF5_INTERJECT}" \
        -DHDF5_INCLUDE_DIRS="${PREFIX}/include" \
        -DHDF5_VERSION="1.8.17"  # NOTICE PIN-TO-BUILD!

    if [ "${PSI_BUILD_CCFAM}" == "gnu" ]; then
        # prevent lgomp being linked and allow liomp5
        sed -i '' "s|-fopenmp||g" ${SRC_DIR}/build/CheMPS2/CMakeFiles/chemps2-shared.dir/link.txt
        sed -i '' "s|-fopenmp||g" ${SRC_DIR}/build/CheMPS2/CMakeFiles/chemps2-bin.dir/link.txt
    fi
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    set +x
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64
    set -x

    # link against older libc for generic linux
    #   PREFIX needs to contain a libgcc_s.so of libc <2.14
    TLIBC=/home/psilocaluser/installs/glibc2.12
    LIBC_INTERJECT="-liomp5;${TLIBC}/lib64/librt.so.1;${TLIBC}/lib64/libpthread.so.0;${TLIBC}/lib64/libm.so.6;dl;${PREFIX}/lib/libgcc_s.so;${TLIBC}/lib64/libc.so.6"

    # force static link to Intel mkl, except for openmp
    #MKLROOT=/theoryfs2/common/software/intel2016/compilers_and_libraries_2016.2.181/linux/mkl/lib/intel64
    #LAPACK_INTERJECT="-Wl,--start-group;${MKLROOT}/libmkl_cdft_core.a;${MKLROOT}/libmkl_intel_lp64.a;${MKLROOT}/libmkl_intel_thread.a;${MKLROOT}/libmkl_core.a;${MKLROOT}/libmkl_blacs_intelmpi_lp64.a;-Wl,--end-group;-liomp5;-lpthread;${TLIBC}/lib64/libm.so.6;-ldl"
    MKLROOT="${PREFIX}/lib"
    LAPACK_INTERJECT="-Wl,--start-group;${MKLROOT}/libmkl_cdft_core.a;${MKLROOT}/libmkl_rt.so;${MKLROOT}/libmkl_blacs_intelmpi_lp64.a;-Wl,--end-group;-liomp5;-lpthread;${TLIBC}/lib64/libm.so.6;-ldl"

    ## link against older (pre-2.14 libc-based) hdf5 & zlib either:
    ## (a) explicitly
    HDF5_INTERJECT="${PREFIX}/lib/libhdf5.so;${PREFIX}/lib/libhdf5_hl.so;${PREFIX}/lib/libhdf5.so;-lrt;${PREFIX}/lib/libz.so.1.2.11;-ldl;${TLIBC}/lib64/libm.so.6"
    #    -DHDF5_LIBRARIES="${HDF5_INTERJECT}"
    #    -DHDF5_INCLUDE_DIRS="${PREFIX}/include"
    ## (b) by having them detectable, probably through a "source activate hdf5zlibenv"
    #source activate py2basics

    # build multi-instruction-set library
    OPTS="-msse2 -axCORE-AVX2,AVX"

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_C_FLAGS="${OPTS}" \
        -DCMAKE_CXX_FLAGS="${OPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DSHARED_ONLY=ON \
        -DENABLE_OPENMP=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON \
        -DMKL=ON \
        -DBUILD_DOXYGEN=OFF \
        -DBUILD_SPHINX=OFF \
        -DENABLE_TESTS=OFF \
        -DLIBC_INTERJECT=${LIBC_INTERJECT} \
        -DLAPACK_LIBRARIES=${LAPACK_INTERJECT} \
        -DHDF5_LIBRARIES=${HDF5_INTERJECT} \
        -DHDF5_INCLUDE_DIRS="${PREFIX}/include" \
        -DHDF5_VERSION="1.8.17"  # NOTICE PIN!
fi

        #-DLAPACK_INTERJECT=${LAPACK_INTERJECT} \
#        -DCMAKE_C_FLAGS="-gcc-name=${PREFIX}/bin/gcc" \
#        -DCMAKE_CXX_FLAGS="-gcc-name=${PREFIX}/bin/gcc -gxx-name=${PREFIX}/bin/g++" \

# build
cd build
make -j${CPU_COUNT}
#make VERBOSE=1

# install
make install

if [ "$(uname)" == "Linux" ]; then
    # generalize the interface_link_libraries for export where overly specified
    #   during compilation just to suppress glibc 2.14 dependence
    sed -i "s|${TLIBC}/lib64/libm.so.6|-lm|g" ${PREFIX}/share/cmake/CheMPS2/CheMPS2Targets-shared.cmake
    sed -i "s|libz.so.1.2.11|libz.so|g" ${PREFIX}/share/cmake/CheMPS2/CheMPS2Targets-shared.cmake
fi

# test
# tests segfault on mac, hence off. some path issue on Linux, I think
# on Linux, loader and glibc mismatch at build time. remedied by test environment.
#make test

#add_library(s::hdf5 INTERFACE IMPORTED)
#set_property(TARGET s::hdf5 PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${HDF5_INCLUDE_DIRS})
#set_property(TARGET s::hdf5 PROPERTY INTERFACE_LINK_LIBRARIES ${HDF5_LIBRARIES})

#   '-Wl,-Bstatic;ifport;ifcore;imf;svml;     m;ipgo;                       irc;pthread;svml;c;irc_s;dl;c'
#                              'imf;svml;irng;m;ipgo;decimal;cilkrts;stdc++;irc;        svml;c;irc_s;dl;c')
