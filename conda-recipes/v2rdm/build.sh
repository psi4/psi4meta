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
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64
    set -x

    # link against older libc for generic linux
    TLIBC=/home/psilocaluser/installs/glibc2.12
    LIBC_INTERJECT="-liomp5;${TLIBC}/lib64/libc.so.6;-Wl,-Bstatic;-Wl,--whole-archive;-lifport;-lifcoremt_pic;-Wl,--no-whole-archive;-Wl,-Bdynamic"

    # build multi-instruction-set library
    OPTS="-msse2 -axCORE-AVX2,AVX"

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
        -DCMAKE_CXX_FLAGS=" -qopenmp -Wl,--as-needed -static-libstdc++ -static-libgcc -static-intel -wd10237 ${OPTS}" \
        -DCMAKE_Fortran_FLAGS=" -qopenmp -static-libgcc -static-intel -wd10006 ${OPTS}"
fi

# build
make -j${CPU_COUNT}
#make VERBOSE=1

# install
make install

# Note: to build from psi4 package cache
#        -C ${PREFIX}/share/cmake/psi4/psi4PluginCache.cmake \
