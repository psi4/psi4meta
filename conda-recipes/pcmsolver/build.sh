# conda's setting of CFLAGS interferes with PCMSolver CMake settings, so clear
KEEPCFLAGS=$CFLAGS
KEEPFCFLAGS=$FCFLAGS
KEEPCXXFLAGS=$CXXFLAGS
KEEPLDFLAGS=$LDFLAGS
unset CFLAGS
unset FCFLAGS
unset CXXFLAGS
unset LDFLAGS

if [ "$(uname)" == "Darwin" ]; then

    # link against conda Clang
    CMAKE_C_FLAGS="${KEEPCFLAGS} ${OPTS}"
    CMAKE_CXX_FLAGS="${KEEPCXXFLAGS} ${OPTS}"

    # for FortranCInterface
    CMAKE_Fortran_FLAGS="${KEEPFFLAGS} -L${CONDA_BUILD_SYSROOT}/usr/lib/system/ ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=${CLANG} \
        -DCMAKE_CXX_COMPILER=${CLANGXX} \
        -DCMAKE_Fortran_COMPILER=${GFORTRAN} \
        -DCMAKE_C_FLAGS="${CMAKE_C_FLAGS}" \
        -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS}" \
        -DCMAKE_Fortran_FLAGS="${CMAKE_Fortran_FLAGS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="/python${PY_VER}/site-packages" \
        -DPYTHON_INTERPRETER=${PYTHON} \
        -DENABLE_OPENMP=OFF \
        -DENABLE_GENERIC=OFF \
        -DENABLE_DOCS=OFF \
        -DENABLE_TESTS=ON \
        -DENABLE_TIMER=OFF \
        -DENABLE_LOGGER=OFF \
        -DBUILD_STANDALONE=OFF \
        -DENABLE_FORTRAN_API=OFF \
        -DENABLE_CXX11_SUPPORT=ON
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2019/bin/compilervars.sh intel64
    set -x

    # link against conda GCC
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # squash Intel fortran libs
    LIBC_INTERJECT="-liomp5;-Wl,-Bstatic;-lifport;-lifcoremt_pic;-Wl,-Bdynamic"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_C_FLAGS="${ALLOPTS}" \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DCMAKE_Fortran_COMPILER=ifort \
        -DCMAKE_Fortran_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="/python${PY_VER}/site-packages" \
        -DPYTHON_INTERPRETER=${PYTHON} \
        -DENABLE_OPENMP=OFF \
        -DENABLE_GENERIC=OFF \
        -DLIBC_INTERJECT="${LIBC_INTERJECT}" \
        -DENABLE_DOCS=OFF \
        -DENABLE_TESTS=ON \
        -DENABLE_TIMER=OFF \
        -DENABLE_LOGGER=OFF \
        -DBUILD_STANDALONE=OFF \
        -DENABLE_FORTRAN_API=OFF \
        -DENABLE_CXX11_SUPPORT=ON
fi

        #-DCMAKE_C_COMPILER=${GCC} \
        #-DCMAKE_C_FLAGS="${CFLAGS}" \
        #-DCMAKE_CXX_COMPILER=${GXX} \
        #-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        #-DCMAKE_Fortran_COMPILER=${GFORTRAN} \
        #-DCMAKE_Fortran_FLAGS="${FFLAGS}" \

# build
cd build
make -j${CPU_COUNT}

# install
make install
rm ${PREFIX}/share/cmake/PCMSolver/PCMSolverTargets-static-release.cmake
rm ${PREFIX}/share/cmake/PCMSolver/PCMSolverTargets-static.cmake
rm ${PREFIX}/lib/libpcm.a

# test
# green_spherical_diffuse hitting an Intel 2018+Eigen bug
# but they can be run if static lib is built
if [ "$(uname)" == "Darwin" ]; then
    install_name_tool -add_rpath ${PREFIX}/lib/ lib/libpcm.1.dylib
    install_name_tool -add_rpath ${PREFIX}/lib/ bin/unit_tests
    install_name_tool -add_rpath ${PREFIX}/lib/ bin/Fortran_host
    ctest -j${CPU_COUNT}
fi
if [ "$(uname)" == "Linux" ]; then
    ctest -E "green_spherical_diffuse" -j${CPU_COUNT}
fi

export CFLAGS=KEEPCFLAGS
export FCFLAGS=KEEPFCFLAGS
export CXXFLAGS=KEEPCXXFLAGS
export LDFLAGS=KEEPLDFLAGS

# Notes
# -----

# * [Apr 2018] Removing -DSHARED_LIBRARY_ONLY=ON so that can build
#   and run tests. We don't want to distribute static libs in a conda
#   pkg though, and unless user sets static/shared component, can't trust
#   `find_package(PCMSolver)` to return shared. So removing all the static
#   lib stuff immediately after install.

#     force Intel compilers to find 5.2 gcc headers
#    export GXX_INCLUDE="${PREFIX}/gcc/include/c++"
#    export GXX_INCLUDE="${BUILD_PREFIX}/${HOST}/include/c++/7.2.0/bits/stl_vector.h"

#if [ "$(uname)" == "Linux" ]; then
#
#      LD_LIBRARY_PATH=${PREFIX}/lib:$LD_LIBRARY_PATH \
#           PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib/${PYMOD_INSTALL_LIBDIR}:$PYTHONPATH \
#                 PATH=${PREFIX}/bin:$PATH \
#        ctest -j${CPU_COUNT}
#fi
