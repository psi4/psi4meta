# conda's setting of CFLAGS interferes with PCMSolver CMake settings, so clear
KEEPCFLAGS=$CFLAGS
unset CFLAGS

if [ "$(uname)" == "Darwin" ]; then

    rm -f ${PREFIX}/lib/libsqlite3*

    # conda gnu compilers
    CC="${PREFIX}/bin/gcc"
    CXX="${PREFIX}/bin/g++"
    F90="${PREFIX}/bin/gfortran"
    GENERIC=OFF
    LIBC_INTERJECT="''"
    LAPACK_INTERJECT="''"

fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64

    CC=icc
    CXX=icpc
    F90=ifort
    GENERIC=ON

    # force static link to Intel mkl, except for openmp
    MKLROOT=/theoryfs2/common/software/intel2016/compilers_and_libraries_2016.2.181/linux/mkl/lib/intel64
    COMPROOT=${MKLROOT}/../../../compiler/lib/intel64
    LAPACK_INTERJECT="${COMPROOT}/libifport.a ${COMPROOT}/libifcore_pic.a"
    # link against older libc for generic linux
    TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/psi4cmake/psi4/glibc2.12rpm
    LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6"

fi


mkdir build
cd build
cmake \
 -DCMAKE_C_COMPILER=${CC} \
 -DCMAKE_CXX_COMPILER=${CXX} \
 -DCMAKE_Fortran_COMPILER=${F90} \
 -DEXTRA_CXXFLAGS="''" \
 -DEXTRA_CFLAGS="''" \
 -DEXTRA_FCFLAGS="''" \
 -DCMAKE_OSX_DEPLOYMENT_TARGET='' \
 -DENABLE_EXTENDED_DIAGNOSTICS=False \
 -DUSE_CCACHE="OFF" \
 -DENABLE_CODE_COVERAGE=False \
 -DENABLE_64BIT_INTEGERS=False \
 -DENABLE_OPENMP=False \
 -DPYTHON_INTERPRETER=${PYTHON} \
 -DBOOST_INCLUDEDIR="${PREFIX}/include" \
 -DBOOST_LIBRARYDIR="${PREFIX}/lib" \
 -DFORCE_CUSTOM_BOOST="OFF" \
 -DBOOST_MINIMUM_REQUIRED="1.54.0" \
 -DBOOST_COMPONENTS_REQUIRED="" \
 -DSTATIC_LIBRARY_ONLY=False \
 -DCMAKE_BUILD_TYPE=release \
 -G "Unix Makefiles" \
 -DENABLE_GENERIC=${GENERIC} \
 -DLIBC_INTERJECT="${LIBC_INTERJECT} ${LAPACK_INTERJECT}" \
 -DENABLE_CXX11_SUPPORT=ON \
 -DENABLE_TIMER=OFF \
 -DBUILD_STANDALONE=OFF \
 -DZLIB_ROOT=${PREFIX} \
 -DENABLE_DOCS=OFF \
 -DENABLE_TESTS=ON \
 -DCMAKE_INSTALL_PREFIX=${PREFIX} \
 -DCMAKE_INSTALL_LIBDIR=lib \
 ${SRC_DIR}

make -j${CPU_COUNT}
#make VERBOSE=1

# install
make install

# test
if [ "$(uname)" == "Darwin" ]; then

    DYLD_LIBRARY_PATH=${PREFIX}/lib:$DYLD_LIBRARY_PATH \
           PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib/python2.7/site-packages:$PYTHONPATH \
                 PATH=${PREFIX}/bin:$PATH \
        ctest -j${CPU_COUNT}
fi

if [ "$(uname)" == "Linux" ]; then

      LD_LIBRARY_PATH=${PREFIX}/lib:$LD_LIBRARY_PATH \
           PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib/python2.7/site-packages:$PYTHONPATH \
                 PATH=${PREFIX}/bin:$PATH \
        ctest -j${CPU_COUNT}
fi

export CFLAGS=KEEPFLAGS

