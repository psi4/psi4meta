# conda's setting of CFLAGS interferes with PCMSolver CMake settings, so clear
KEEPCFLAGS=$CFLAGS
unset CFLAGS

# collect the py-dep path pieces
if [ "${CONDA_PY}" == "27" ]; then
    PYMOD_INSTALL_LIBDIR="/python2.7/site-packages"
    PY_ABBR="python2.7"
elif [ "${CONDA_PY}" == "35" ]; then
    PYMOD_INSTALL_LIBDIR="/python3.5/site-packages"
    PY_ABBR="python3.5m"
fi

if [ "$(uname)" == "Darwin" ]; then

#    rm -f ${PREFIX}/lib/libsqlite3*

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_Fortran_COMPILER=${PREFIX}/bin/gfortran \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR=${PYMOD_INSTALL_LIBDIR} \
        -DPYTHON_INTERPRETER=${PYTHON} \
        -DSHARED_LIBRARY_ONLY=ON \
        -DENABLE_OPENMP=ON \
        -DENABLE_GENERIC=OFF \
        -DENABLE_DOCS=OFF \
        -DENABLE_TESTS=ON \
        -DENABLE_TIMER=OFF \
        -DENABLE_LOGGER=OFF \
        -DBUILD_STANDALONE=OFF \
        -DENABLE_FORTRAN_API=OFF \
        -DENABLE_CXX11_SUPPORT=ON
#        -DLIBC_INTERJECT=${LIBC_INTERJECT} \
#        -DCMAKE_CXX_FLAGS="-gcc-name=${PFXC}/bin/gcc -gxx-name=${PFXC}/bin/g++" \
#        -DCMAKE_Fortran_FLAGS="-gcc-name=${PFXC}/bin/gcc -gxx-name=${PFXC}/bin/g++"
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    set +x
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64
    set -x

    # link against older libc for generic linux
    # force static link to Intel libs, except for openmp
    TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/nightly/glibc2.12
    LIBC_INTERJECT="-liomp5;${TLIBC}/lib64/libpthread.so.0;${TLIBC}/lib64/libc.so.6;-Wl,-Bstatic;-lifport;-lifcoremt_pic;-Wl,-Bdynamic"

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_Fortran_COMPILER=ifort \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR=${PYMOD_INSTALL_LIBDIR} \
        -DPYTHON_INTERPRETER=${PYTHON} \
        -DSHARED_LIBRARY_ONLY=ON \
        -DENABLE_OPENMP=ON \
        -DENABLE_GENERIC=ON \
        -DENABLE_DOCS=OFF \
        -DENABLE_TESTS=ON \
        -DENABLE_TIMER=OFF \
        -DENABLE_LOGGER=OFF \
        -DBUILD_STANDALONE=OFF \
        -DENABLE_FORTRAN_API=OFF \
        -DENABLE_CXX11_SUPPORT=ON \
        -DLIBC_INTERJECT=${LIBC_INTERJECT} \
        -DCMAKE_CXX_FLAGS="-gcc-name=${PFXC}/bin/gcc -gxx-name=${PFXC}/bin/g++" \
        -DCMAKE_Fortran_FLAGS="-gcc-name=${PFXC}/bin/gcc -gxx-name=${PFXC}/bin/g++"
fi

#cmake \
# -DEXTRA_CXXFLAGS="''" \
# -DEXTRA_CFLAGS="''" \
# -DEXTRA_FCFLAGS="''" \
# -DCMAKE_OSX_DEPLOYMENT_TARGET='' \
# -DENABLE_EXTENDED_DIAGNOSTICS=False \
# -DUSE_CCACHE="OFF" \
# -DENABLE_CODE_COVERAGE=False \
# -DENABLE_64BIT_INTEGERS=False \
# -DENABLE_OPENMP=ON \
# -DPYTHON_INTERPRETER=${PYTHON} \
# -DBOOST_INCLUDEDIR="${PREFIX}/include" \
# -DBOOST_LIBRARYDIR="${PREFIX}/lib" \
# -DFORCE_CUSTOM_BOOST="OFF" \
# -DBOOST_MINIMUM_REQUIRED="1.54.0" \
# -DBOOST_COMPONENTS_REQUIRED="" \
# -DSTATIC_LIBRARY_ONLY=False \
# -DCMAKE_BUILD_TYPE=release \
# -G "Unix Makefiles" \
# -DENABLE_GENERIC=${GENERIC} \
# -DLIBC_INTERJECT="${LIBC_INTERJECT}" \
# -DENABLE_CXX11_SUPPORT=ON \
# -DENABLE_TIMER=OFF \
# -DBUILD_STANDALONE=OFF \
# -DZLIB_ROOT=${PREFIX} \
# -DENABLE_DOCS=OFF \
# -DENABLE_TESTS=ON \
# -DCMAKE_INSTALL_PREFIX=${PREFIX} \
# -DCMAKE_INSTALL_LIBDIR=lib \
# ${SRC_DIR}

# build
cd build
make -j${CPU_COUNT}
#make VERBOSE=1

# install
make install

# test
if [ "$(uname)" == "Darwin" ]; then

    DYLD_LIBRARY_PATH=${PREFIX}/lib:$DYLD_LIBRARY_PATH \
           PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib/${PYMOD_INSTALL_LIBDIR}:$PYTHONPATH \
                 PATH=${PREFIX}/bin:$PATH \
        ctest -j${CPU_COUNT}
fi

if [ "$(uname)" == "Linux" ]; then

      LD_LIBRARY_PATH=${PREFIX}/lib:$LD_LIBRARY_PATH \
           PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib/${PYMOD_INSTALL_LIBDIR}:$PYTHONPATH \
                 PATH=${PREFIX}/bin:$PATH \
        ctest -j${CPU_COUNT}
fi

export CFLAGS=KEEPFLAGS

