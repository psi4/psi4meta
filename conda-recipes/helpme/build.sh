
#if [ "$(uname)" == "Darwin" ]; then
#
#    # link against conda Clang
#    # * -fno-exceptions squashes `___gxx_personality_v0` symbol and thus libc++ dependence
#    ALLOPTS="-clang-name=${CLANG} ${OPTS} -fno-exceptions"
#    ALLOPTSCXX="-clang-name=${CLANG} -clangxx-name=${CLANGXX} -stdlib=libc++ -I${PREFIX}/include/c++/v1 ${OPTS} -fno-exceptions -mmacosx-version-min=10.9"
#
#    # configure
#    ${BUILD_PREFIX}/bin/cmake \
#        -H${SRC_DIR} \
#        -Bbuild \
#        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
#        -DCMAKE_BUILD_TYPE=Release \
#        -DCMAKE_C_COMPILER=icc \
#        -DCMAKE_CXX_COMPILER=icpc \
#        -DCMAKE_C_FLAGS="${ALLOPTS}" \
#        -DCMAKE_CXX_FLAGS="${ALLOPTSCXX}" \
#        -DCMAKE_INSTALL_LIBDIR=lib \
#        -DMAX_AM_ERI=${MAX_AM_ERI} \
#        -DBUILD_SHARED_LIBS=ON \
#        -DMERGE_LIBDERIV_INCLUDEDIR=ON \
#        -DENABLE_XHOST=OFF
#fi

#rm -rf objdir/ && cmake -H. -Bobjdir -DCMAKE_INSTALL_PREFIX=/home/psilocaluser/gits/helpme/install -DFFTW_ROOT=/home/psilocaluser/toolchainconda/envs/p4dev37/ -DPYTHON_EXECUTABLE=${CONDA_PREFIX}/bin/python -DBUILD_SHARED_LIBS=ON

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2018/bin/compilervars.sh intel64
    set -x

#    if [ "$blas_impl" = "mkl" ]; then
#        LAPACK_INTERJECT="${PREFIX}/lib/libmkl_rt${SHLIB_EXT};-Wl,-Bstatic;-lsvml;-Wl,-Bdynamic"
#    else
#        LAPACK_INTERJECT="${PREFIX}/lib/libopenblas${SHLIB_EXT}"
#    fi
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"  # GREAT, but saving time

#    # link against conda GCC
#    # * lang defined as CXX in CMake (file extension reasons), so $OPTS brings
#    #   libstdc++, hence the ENABLE_GENERIC=ON
#    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_Fortran_COMPILER=ifort \
        -DCMAKE_C_FLAGS="${ALLOPTS}" \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DCMAKE_Fortran_FLAGS="${ALLOPTS}" \
        -DENABLE_Fortran=ON \
        -DINSTALL_PYMOD=ON \
        -DFFTW_ROOT=${PREFIX} \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="/python${PY_VER}/site-packages" \
        -DBUILD_SHARED_LIBS=ON \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/libpython${PY_VER}m${SHLIB_EXT}" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/python${PY_VER}m" \
        -DCMAKE_PREFIX_PATH="${PREFIX}" \
        -DENABLE_OPENMP=ON \
        -DENABLE_XHOST=OFF

        #-DLAPACK_LIBRARIES="${LAPACK_INTERJECT}" \

        #-DENABLE_GENERIC=ON

        #-DCMAKE_INSIST_FIND_PACKAGE_pybind11=ON \
        #-DENABLE_GENERIC=OFF \


fi

# build
cd build
make -j${CPU_COUNT}

# install
make install

# test
ctest


# <<<  Notes  >>>

# * Recipe won't build if conda path has double slash. Error:
#
#   CMake Error at cmake_install.cmake:31 (file):
#     file called with network path DESTINATION.  This does not make sense when
#     using DESTDIR.  Specify local absolute path or remove DESTDIR environment
#     variable.
#
#     DESTINATION=
#
#     //anaconda/envs/_build/bin
