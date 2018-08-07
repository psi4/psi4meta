
if [ "$(uname)" == "Darwin" ]; then

    # link against conda MKL & Clang
    if [ "$blas_impl" = "mkl" ]; then
        LAPACK_INTERJECT="${PREFIX}/lib/libmkl_rt${SHLIB_EXT}"
    fi

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=${CLANG} \
        -DCMAKE_CXX_COMPILER=${CLANGXX} \
        -DCMAKE_C_FLAGS="${CFLAGS} ${OPTS}" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS} ${OPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}${SHLIB_EXT}" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_OPENMP=OFF \
        -DCMAKE_INSIST_FIND_PACKAGE_pybind11=ON \
        -DCMAKE_DISABLE_FIND_PACKAGE_libefp=ON \
        -DENABLE_XHOST=OFF \
        -DFRAGLIB_UNDERSCORE_L=OFF \
        -DFRAGLIB_DEEP=OFF \
        -DINSTALL_DEVEL_HEADERS=ON \
        -Dpybind11_DIR="${PREFIX}/share/cmake/pybind11" \
        -DLAPACK_LIBRARIES=${LAPACK_INTERJECT}
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2018/bin/compilervars.sh intel64
    set -x

    # link against conda MKL & GCC
    if [ "$blas_impl" = "mkl" ]; then
        LAPACK_INTERJECT="${PREFIX}/lib/libmkl_rt.so"
    else
        LAPACK_INTERJECT="${PREFIX}/lib/libopenblas.so"
    fi
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_C_FLAGS="${ALLOPTS}" \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}.so" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_OPENMP=OFF \
        -DCMAKE_INSIST_FIND_PACKAGE_pybind11=ON \
        -DCMAKE_DISABLE_FIND_PACKAGE_libefp=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON \
        -DFRAGLIB_UNDERSCORE_L=OFF \
        -DFRAGLIB_DEEP=OFF \
        -DINSTALL_DEVEL_HEADERS=ON \
        -Dpybind11_DIR="${PREFIX}/share/cmake/pybind11" \
        -DLAPACK_LIBRARIES=${LAPACK_INTERJECT}
fi

# build
cd build
make -j${CPU_COUNT}

# install
make install

# test
# pytest in conda testing stage

if [ -x "$(command -v ${PREFIX}/bin/sphinx-build)" ]; then

    # docs build
    make sphinxman -j${CPU_COUNT}

    # install docs
    make install

    if [[ -d "doc/html" ]]; then
        # Upon sucessful docs build, tar 'em up and mv to dir to await beaming up to psicode.org

        cd doc
        mv html master
        tar -zcf cb-sphinxman-pylibefp.tar.gz master/
        mv -f cb-sphinxman-pylibefp.tar.gz /home/psilocaluser/gits/psi4meta/psicode_dropbox/

        cd ..
    fi
fi

# NOTES
# -----
# Note: add -DCMAKE_C_FLAGS="-liomp5" for static link w/o mkl
# Note: gcc4.8.5 just fine; using 5.2 for consistency.
# Note: older static MKL
    # force static link to Intel mkl, except for openmp
    #MKLROOT=/theoryfs2/common/software/intel2016/compilers_and_libraries_2016.2.181/linux/mkl/lib/intel64
    #LAPACK_INTERJECT="${MKLROOT}/libmkl_lapack95_lp64.a;-Wl,--start-group;${MKLROOT}/libmkl_intel_lp64.a;${MKLROOT}/libmkl_sequential.a;${MKLROOT}/libmkl_core.a;-Wl,--end-group;-lpthread;-lm;-ldl"

    #LAPACK_LIBRARIES="${PREFIX}/lib/libmkl_rt.so;${PREFIX}/lib/libiomp5.so;-fno-openmp;-lpthread;-lm;-ldl"
    #LAPACK_INCLUDE_DIRS="${PREFIX}/include"
    ## link against older libc for generic linux
    #TLIBC=/home/psilocaluser/installs/glibc2.12
    #LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6"
