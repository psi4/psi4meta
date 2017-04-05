# conda's setting of CFLAGS interferes with PCMSolver CMake settings, so clear
KEEPCFLAGS=$CFLAGS
KEEPCXXFLAGS=$CXXFLAGS
unset CFLAGS
unset CXXFLAGS

# collect the py-dep path pieces
if [ "${CONDA_PY}" == "27" ]; then
    PYMOD_INSTALL_LIBDIR="/python2.7/site-packages"
    PY_ABBR="python2.7"
elif [ "${CONDA_PY}" == "35" ]; then
    PYMOD_INSTALL_LIBDIR="/python3.5/site-packages"
    PY_ABBR="python3.5m"
elif [ "${CONDA_PY}" == "36" ]; then
    PYMOD_INSTALL_LIBDIR="/python3.6/site-packages"
    PY_ABBR="python3.6m"
fi

if [ "$(uname)" == "Darwin" ]; then

    rm -f ${PREFIX}/lib/libsqlite3*

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
        -DENABLE_CXX11_SUPPORT=ON \
        -DCMAKE_CXX_FLAGS="-stdlib=libc++"
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    set +x
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64
    set -x

    # link against older libc for generic linux
    # force static link to Intel libs, except for openmp
    TLIBC=/home/psilocaluser/installs/glibc2.12
    LIBC_INTERJECT="-liomp5;${TLIBC}/lib64/libpthread.so.0;${TLIBC}/lib64/libc.so.6;-Wl,-Bstatic;-lifport;-lifcoremt_pic;-Wl,-Bdynamic"

    # force Intel compilers to find 5.2 gcc headers
    export GXX_INCLUDE="${PREFIX}/gcc/include/c++"

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
        -DLIBC_INTERJECT="${LIBC_INTERJECT}" \
        -DCMAKE_CXX_FLAGS="-gcc-name=${PREFIX}/bin/gcc -gxx-name=${PREFIX}/bin/g++" \
        -DCMAKE_Fortran_FLAGS="-gcc-name=${PREFIX}/bin/gcc -gxx-name=${PREFIX}/bin/g++"
fi

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

export CFLAGS=KEEPCFLAGS
export CXXFLAGS=KEEPCXXFLAGS

# Note: Alternative to gcc/gxx-name for CXX:  #-DCMAKE_CXX_FLAGS="-cxxlib=${PREFIX}" \
