
psi4 --version

if [ "$(uname)" == "Darwin" ]; then

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -B. \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER="${CLANG}" \
        -DCMAKE_CXX_COMPILER="${CLANGXX}" \
        -DCMAKE_Fortran_COMPILER="${GFORTRAN}" \
        -DCMAKE_C_FLAGS="${CFLAGS} ${OPTS}" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS} ${OPTS}" \
        -DCMAKE_Fortran_FLAGS="${FFLAGS} ${OPTS}" \
        -DENABLE_OPENMP=ON \
        -DOpenMP_C_FLAG="-fopenmp=libiomp5" \
        -DOpenMP_CXX_FLAG="-fopenmp=libiomp5" \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_XHOST=OFF
fi


if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    set +x
    source /theoryfs2/common/software/intel2018/bin/compilervars.sh intel64
    set -x

    # link against older libc for generic linux
    #LIBC_INTERJECT="-liomp5;-Wl,-Bstatic;-Wl,--whole-archive;-lifport;-lifcoremt_pic;-Wl,--no-whole-archive;-Wl,-Bdynamic"
    LIBC_INTERJECT="-liomp5;-Wl,-Bstatic;-lifport;-lifcoremt_pic;-Wl,-Bdynamic"
    #LIBC_INTERJECT="-Wl,-Bstatic;-lifport;-lifcoremt_pic;-Wl,-Bdynamic"
    #LIBC_INTERJECT=""

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

        #-DCMAKE_CXX_FLAGS=" -qopenmp -Wl,--as-needed -static-libstdc++ -static-libgcc -static-intel -wd10237 ${ALLOPTS}" \
        #-DCMAKE_Fortran_FLAGS=" -qopenmp -static-libgcc -static-intel -wd10006 ${ALLOPTS}" \
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
