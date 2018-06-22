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

#if [ "${PSI_BUILD_ISA}" == "sse41" ]; then
#    ISA="-msse4.1"
#elif [ "${PSI_BUILD_ISA}" == "avx2" ]; then
#    ISA="-march=native"
#fi
#
#
#if [ "$(uname)" == "Darwin" ]; then
#
#    # configure
#    ${PREFIX}/bin/cmake \
#        -H${SRC_DIR} \
#        -Bbuild \
#        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
#        -DCMAKE_BUILD_TYPE=Release \
#        -DCMAKE_C_COMPILER=clang \
#        -DCMAKE_C_FLAGS="${ISA}" \
#        -DCMAKE_INSTALL_LIBDIR=lib \
#        -DBUILD_SHARED_LIBS=ON \
#        -DENABLE_XHOST=OFF \
#        -DENABLE_OPENMP=OFF \
#        -DFRAGLIB_UNDERSCORE_L=OFF \
#        -DFRAGLIB_DEEP=OFF \
#        -DINSTALL_DEVEL_HEADERS=ON \
#        -DLAPACK_LIBRARIES="${PREFIX}/lib/libmkl_rt.dylib"
#fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    set +x
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64
    set -x

#    # force static link to Intel mkl, except for openmp
#    #MKLROOT=/theoryfs2/common/software/intel2016/compilers_and_libraries_2016.2.181/linux/mkl/lib/intel64
#    #LAPACK_INTERJECT="${MKLROOT}/libmkl_lapack95_lp64.a;-Wl,--start-group;${MKLROOT}/libmkl_intel_lp64.a;${MKLROOT}/libmkl_sequential.a;${MKLROOT}/libmkl_core.a;-Wl,--end-group;-lpthread;-lm;-ldl"
#    LAPACK_INTERJECT="${PREFIX}/lib/libmkl_rt.so"

    # link against older libc for generic linux
    TLIBC=/home/psilocaluser/installs/glibc2.12
    LIBC_INTERJECT="${TLIBC}/lib64/libc.so.6"

    # build multi-instruction-set library
    OPTS="-msse2 -axCORE-AVX2,AVX"
    OPTS="-march=core2 "

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=gcc \
        -DCMAKE_CXX_COMPILER=g++ \
        -DCMAKE_C_FLAGS="${OPTS}" \
        -DCMAKE_CXX_FLAGS="${OPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}.so" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DLIBC_INTERJECT="${LIBC_INTERJECT}" \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON
        #-DLAPACK_LIBRARIES=${LAPACK_INTERJECT}
        #-DCMAKE_PREFIX_PATH="${PREFIX}" \
        #-DLAPACK_LIBRARIES="${LAPACK_LIBRARIES}" \
        #-DLAPACK_INCLUDE_DIRS="${LAPACK_INCLUDE_DIRS}" \
        #-DBUILD_SHARED_LIBS=ON \
        #-DENABLE_OPENMP=OFF \
        #-DCMAKE_C_COMPILER=icc \
        #-DCMAKE_CXX_COMPILER=icpc \
fi
    #LAPACK_LIBRARIES="${PREFIX}/lib/libmkl_rt.so;${PREFIX}/lib/libiomp5.so;-fno-openmp;-lpthread;-lm;-ldl"
    #LAPACK_INCLUDE_DIRS="${PREFIX}/include"
    ## link against older libc for generic linux
    #TLIBC=/home/psilocaluser/installs/glibc2.12
    #LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6"

# build
cd build
make -j${CPU_COUNT}
#make VERBOSE=1

# install
make install

# test
# pytest in conda testing stage
