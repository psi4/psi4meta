# load Intel compilers and mkl
source /theoryfs2/common/software/intel2015/bin/compilervars.sh intel64
# force static link to Intel mkl, except for openmp
MKLROOT=/theoryfs2/common/software/intel2015/composer_xe_2015.0.090/mkl/lib/intel64
LAPACK_INTERJECT="${MKLROOT}/libmkl_intel_lp64.a ${MKLROOT}/libmkl_intel_thread.a ${MKLROOT}/libmkl_core.a -liomp5 -lm"
# link against older libc for generic linux
TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/psi4cmake/psi4/glibc2.12rpm
LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6"
# round off with pre-detected dependencies
#MCONDA=/theoryfs2/ds/cdsgroup/psi4-install/miniconda/envs/gslenv/lib
#GSL_INTERJECT="-L${MCONDA};-lhdf5;-lhdf5_hl;-lhdf5;-lpthread;-lz;-lrt;-ldl;-lm"
#HDF5_INTERJECT="-L${MCONDA};-lgsl;-lgslcblas;-lm"
# redistribute the Intel openmp
REDIST=${MKLROOT}/../../../compiler/lib/intel64/libiomp5.so

mkdir build
cd build
mkdir lib
cp ${REDIST} ${PREFIX}/lib
cmake \
 -DCMAKE_CXX_COMPILER=icpc \
 -DCMAKE_C_COMPILER=icc \
 -DCMAKE_Fortran_COMPILER=ifort \
 -DEXTRA_CXXFLAGS="''" \
 -DEXTRA_CFLAGS="''" \
 -DEXTRA_FCFLAGS="''" \
 -DENABLE_EXTENDED_DIAGNOSTICS=False \
 -DUSE_CCACHE="OFF" \
 -DENABLE_CODE_COVERAGE=False \
 -DENABLE_64BIT_INTEGERS=False \
 -DENABLE_OPENMP=False \
 -DPYTHON_INTERPRETER="''" \
 -DBOOST_INCLUDEDIR="''" \
 -DBOOST_LIBRARYDIR="''" \
 -DFORCE_CUSTOM_BOOST="OFF" \
 -DBOOST_MINIMUM_REQUIRED="1.54.0" \
 -DBOOST_COMPONENTS_REQUIRED="" \
 -DSTATIC_LIBRARY_ONLY=False \
 -DCMAKE_BUILD_TYPE=debug \
 -G "Unix Makefiles" \
 -DENABLE_GENERIC=ON \
 -DENABLE_TIMER=OFF \
 -DBUILD_STANDALONE=OFF \
 -DENABLE_DOCS=OFF \
 -DCMAKE_INSTALL_PREFIX=${PREFIX} \
 -DCMAKE_INSTALL_LIBDIR=lib \
 ${SRC_DIR}
make -j${CPU_COUNT}
make install

