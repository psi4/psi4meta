if [ "$(uname)" == "Darwin" ]; then

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -B. \
        -DCMAKE_INSTALL_PREFIX=${SP_DIR} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_CXX_FLAGS="-stdlib=libc++" \
        -DCMAKE_Fortran_COMPILER="${PREFIX}/bin/gfortran" \
        -DBUILD_SHARED_LIBS=ON
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    set +x
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64
    set -x

    # link against older libc for generic linux
    TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/nightly/glibc2.12
    LIBC_INTERJECT="-liomp5;${TLIBC}/lib64/libc.so.6;-Wl,-Bstatic;-Wl,--whole-archive;-lifport;-lifcoremt_pic;-Wl,--no-whole-archive;-Wl,-Bdynamic"

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -B. \
        -DCMAKE_INSTALL_PREFIX=${SP_DIR} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_Fortran_COMPILER=ifort \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON \
        -DLIBC_INTERJECT=${LIBC_INTERJECT} \
        -DCMAKE_CXX_FLAGS=" -qopenmp -Wl,--as-needed -static-libstdc++ -static-libgcc -static-intel -wd10237" \
        -DCMAKE_Fortran_FLAGS=" -qopenmp -static-libgcc -static-intel -wd10006"
fi

# build
make -j${CPU_COUNT}
#make VERBOSE=1

# install
make install

# Note: to build from psi4 package cache
#        -C ${PREFIX}/share/cmake/psi4/psi4PluginCache.cmake \
