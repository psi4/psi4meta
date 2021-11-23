
psi4 --version
git describe

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
    source /theoryfs2/common/software/intel2021/oneapi/setvars.sh --config="/theoryfs2/common/software/intel2021/oneapi/config-no-intelpython.txt" intel64
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
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/libpython${PY_VER}m${SHLIB_EXT}" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/python${PY_VER}m" \
        -DLIBC_INTERJECT=${LIBC_INTERJECT}

# python trio isn't generally necessary. revisit after psi4-dev ready
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

    # While https://github.com/pybind/pybind11/pull/1678 ironing out (on Mac)
    #sed -i '' "s/-std=c++14 -fopenmp$/-fopenmp/g" CMakeFiles/v2rdm_casscf.dir/flags.make
