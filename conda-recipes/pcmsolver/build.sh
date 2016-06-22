# conda's setting of CFLAGS interferes with PCMSolver CMake settings, so clear
KEEPCFLAGS=$CFLAGS
unset CFLAGS

if [ "$(uname)" == "Darwin" ]; then

    rm ${PREFIX}/lib/libsqlite3*

    # conda gnu compilers
    CXX="${PREFIX}/bin/g++"
    CC="${PREFIX}/bin/gcc"
    F90="${PREFIX}/bin/gfortran"

fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    source /theoryfs2/common/software/intel2015/bin/compilervars.sh intel64
    CXX=icpc
    CC=icc
    F90=ifort

    # force static link to Intel mkl, except for openmp
    MKLROOT=/theoryfs2/common/software/intel2015/composer_xe_2015.3.187/mkl/lib/intel64
    COMPROOT=${MKLROOT}/../../../compiler/lib/intel64
    LAPACK_INTERJECT="${COMPROOT}/libifport.a ${COMPROOT}/libifcore_pic.a"
    # link against older libc for generic linux
    TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/psi4cmake/psi4/glibc2.12rpm
    LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6"

fi


mkdir build
cd build
cmake \
 -DCMAKE_CXX_COMPILER=${CXX} \
 -DCMAKE_C_COMPILER=${CC} \
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
 -DENABLE_GENERIC=OFF \
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

make install

DYLD_LIBRARY_PATH=${PREFIX}/lib ctest -j${CPU_COUNT}

export CFLAGS=KEEPFLAGS

# commented from above
# -DENABLE_GENERIC=ON \ Linux
# -DLIBC_INTERJECT="${LIBC_INTERJECT} ${LAPACK_INTERJECT}" \

  #-DENABLE_64BIT_INTEGERS=
# -- C++ compiler flags    :  -std=c++11 -Qunused-arguments -fcolor-diagnostics -Wl,-U,_host_writer -O0 -DDEBUG -Wall -Wextra -Winit-self -Woverloaded-virtual -Wuninitialized -Wmissing-declarations -Wwrite-strings -Weffc++ -Wdocumentation 
# -- C compiler flags      :  -std=c99 -DRESTRICT=restrict -DFUNDERSCORE=1 -Qunused-arguments -fcolor-diagnostics -O0 -DDEBUG -g3 -Wall -Wextra -Winit-self -Wuninitialized -Wmissing-declarations -Wwrite-strings  
# -- Fortran compiler flags:  -fimplicit-none -fautomatic -fmax-errors=5 -O0 -g -fbacktrace -Wall 
# -- Definitions           : HAS_CXX11;HAS_CXX11_FUNC;HAS_CXX11_AUTO;HAS_CXX11_AUTO_RET_TYPE;HAS_CXX11_CLASS_OVERRIDE;HAS_CXX11_CONSTEXPR;HAS_CXX11_CSTDINT_H;HAS_CXX11_DECLTYPE;HAS_CXX11_INITIALIZER_LIST;HAS_CXX11_LAMBDA;HAS_CXX11_LONG_LONG;HAS_CXX11_NULLPTR;HAS_CXX11_LIB_REGEX;HAS_CXX11_RVALUE_REFERENCES;HAS_CXX11_SIZEOF_MEMBER;HAS_CXX11_STATIC_ASSERT;HAS_CXX11_VARIADIC_TEMPLATES;HAS_CXX11_NOEXCEPT;TAYLOR_CXXIO

# ConfigPCMSolver
#    -DCMAKE_BUILD_TYPE=${PCM_BUILD_TYPE}
#    -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}/interfaces
#?    -DEXTRA_Fortran_FLAGS=${PCM_EXTRA_Fortran_FLAGS}
#    -DEXTRA_C_FLAGS=${PCM_EXTRA_C_FLAGS}
#    -DEXTRA_CXX_FLAGS=${PCM_EXTRA_CXX_FLAGS}
#    -DENABLE_64BIT_INTEGERS=${ENABLE_64BIT_INTEGERS}
#    -DENABLE_TESTS=OFF
#?    -DENABLE_LOGGER=OFF
#    -DENABLE_TIMER=OFF
#?    -DBUILD_STANDALONE=OFF
#    -DENABLE_FORTRAN_API=OFF
#    -DSTATIC_LIBRARY_ONLY=ON
#?    -DENABLE_GENERIC=${ENABLE_STATIC_LINKING}


#  /Users/loriab/anaconda/envs/_build/bin/g++   -arch x86_64 -Wl,-U,_host_writer -O3 -DNDEBUG -dynamiclib -Wl,-headerpad_max_install_names   -arch x86_64 -compatibility_version 1.0.0 -o ../lib/libpcm.1.dylib -install_name @rpath/libpcm.1.dylib cavity/CMakeFiles/cavity.dir/Cavity.cpp.o cavity/CMakeFiles/cavity.dir/Element.cpp.o cavity/CMakeFiles/cavity.dir/GePolCavity.cpp.o cavity/CMakeFiles/cavity.dir/RestartCavity.cpp.o interface/CMakeFiles/interface.dir/Meddle.cpp.o interface/CMakeFiles/interface.dir/Input.cpp.o interface/CMakeFiles/interface.dir/PhysicalConstants.cpp.o metal/CMakeFiles/metal.dir/metal_sphere.F90.o pedra/CMakeFiles/pedra.dir/pedra_cavity.F90.o pedra/CMakeFiles/pedra.dir/pedra_cavity_interface.F90.o pedra/CMakeFiles/pedra.dir/pedra_dblas.F90.o pedra/CMakeFiles/pedra.dir/pedra_dlapack.F90.o pedra/CMakeFiles/pedra.dir/pedra_precision.F90.o pedra/CMakeFiles/pedra.dir/pedra_print.F90.o pedra/CMakeFiles/pedra.dir/pedra_symmetry.F90.o pedra/CMakeFiles/pedra.dir/pedra_utils.F90.o solver/CMakeFiles/solver.dir/CPCMSolver.cpp.o solver/CMakeFiles/solver.dir/IEFSolver.cpp.o utils/CMakeFiles/utils.dir/Atom.cpp.o utils/CMakeFiles/utils.dir/FortranCUtils.cpp.o utils/CMakeFiles/utils.dir/Molecule.cpp.o utils/CMakeFiles/utils.dir/Solvent.cpp.o utils/CMakeFiles/utils.dir/Sphere.cpp.o utils/CMakeFiles/utils.dir/Symmetry.cpp.o utils/CMakeFiles/utils.dir/cnpy.cpp.o utils/getkw/CMakeFiles/getkw.dir/Getkw.cpp.o utils/getkw/CMakeFiles/getkw.dir/GetkwError.cpp.o utils/getkw/CMakeFiles/getkw.dir/Section.cpp.o utils/getkw/CMakeFiles/getkw.dir/messages.cpp.o /Users/loriab/anaconda/envs/_build/lib/libz.dylib -lgfortran -lquadmath -lm 

