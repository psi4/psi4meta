if [ "${PSI_BUILD_ISA}" == "sse41" ]; then
    ISA="-msse4.1"
elif [ "${PSI_BUILD_ISA}" == "avx2" ]; then
    ISA="-march=native"
fi

psi4 --version


if [ "$(uname)" == "Darwin" ]; then

    if [ "${PSI_BUILD_CCFAM}" == "gnu" ]; then
        CC="${PREFIX}/bin/gcc"
        CXX="${PREFIX}/bin/g++"
        CXXFLAGS=""
        LIBC_INTERJECT="-fno-openmp;-liomp5"
    else
        CC="clang"
        CXX="clang++"
        CXXFLAGS="-stdlib=libc++ "
        LIBC_INTERJECT=""
    fi

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -B. \
        -DCMAKE_INSTALL_PREFIX=${SP_DIR} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER="${CC}" \
        -DCMAKE_CXX_COMPILER="${CXX}" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}${ISA}" \
        -DCMAKE_Fortran_COMPILER="${PREFIX}/bin/gfortran" \
        -DCMAKE_Fortran_FLAGS="${ISA}" \
        -DLIBC_INTERJECT=${LIBC_INTERJECT} \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_XHOST=OFF
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    set +x
    source /theoryfs2/common/software/intel2018/bin/compilervars.sh intel64
    set -x

    # suppress Intel Fortran libs
    LIBC_INTERJECT="-liomp5;-Wl,-Bstatic;-lifport;-lifcoremt_pic;-Wl,-Bdynamic"

    # link against conda GCC
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -B. \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_Fortran_COMPILER=ifort \
        -DCMAKE_C_FLAGS="${ALLOPTS}" \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DCMAKE_Fortran_FLAGS="${ALLOPTS}" \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=OFF \
        -DLIBC_INTERJECT=${LIBC_INTERJECT}
fi

# build
make -j${CPU_COUNT}

# install
make install

# NOTES
# -----

# * to build from psi4 package cache
#        -C ${PREFIX}/share/cmake/psi4/psi4PluginCache.cmake \
    #LIBC_INTERJECT="-liomp5;${TLIBC}/lib64/libc.so.6;-Wl,-Bstatic;-Wl,--whole-archive;-lifport;-lifcoremt_pic;-Wl,--no-whole-archive;-Wl,-Bdynamic"
