if [ "$(uname)" == "Darwin" ]; then
    ARCH_ARGS=""

    # c-f-provided CMAKE_ARGS handles CMAKE_OSX_DEPLOYMENT_TARGET, CMAKE_OSX_SYSROOT
fi
if [ "$(uname)" == "Linux" ]; then
    ARCH_ARGS=""

    # c-f/staged-recipes and c-f/*-feedstock on Linux is inside a non-psi4 git repo, messing up psi4's version computation.
    #   The "staged-recipes" and "feedstock_root" skip patterns are now in psi4. Diagnostics below in case any other circs crop up.
    #git rev-parse --is-inside-work-tree
    #git rev-parse --show-toplevel
fi

#########
    # load Intel compilers
    set +x
    source /psi/gits/software/intel/oneapi/setvars.sh intel64
    set -x

    # link against conda MKL & GCC
    # * static svml fixes "undefined symbol: __svml_pow4_mask_e9" for multiarch
    LAPACK_INTERJECT="${PREFIX}/lib/libmkl_rt${SHLIB_EXT};-Wl,-Bstatic;-lsvml;-Wl,-Bdynamic"
    OPTS="-msse2 -axCORE-AVX512,CORE-AVX2,AVX -Wl,--as-needed -static-intel -wd10237"
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"
#########

if [[ "${target_platform}" == "osx-arm64" ]]; then
    export LAPACK_LIBRARIES="${PREFIX}/lib/liblapack${SHLIB_EXT};${PREFIX}/lib/libblas${SHLIB_EXT}"
else
    export LAPACK_LIBRARIES="${PREFIX}/lib/libmkl_rt${SHLIB_EXT}"
fi

echo '__version_long = '"'$PSI4_PRETEND_VERSIONLONG'" > psi4/metadata.py

# Note: bizarrely, Linux (but not Mac) using `-G Ninja` hangs on [205/1223] at
#   c-f/staged-recipes Azure CI --- thus the fallback to GNU Make.

LD_PRELOAD=${BUILD_PREFIX}/lib/libstdc++.so \
${BUILD_PREFIX}/bin/cmake ${CMAKE_ARGS} ${ARCH_ARGS} \
  -S ${SRC_DIR} \
  -B build \
  -D CMAKE_INSTALL_PREFIX=${PREFIX} \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_C_COMPILER=icc \
  -D CMAKE_CXX_COMPILER=icpc \
  -D CMAKE_Fortran_COMPILER=ifort \
  -D CMAKE_C_FLAGS="${ALLOPTS}" \
  -D CMAKE_CXX_FLAGS="${ALLOPTS}" \
  -D CMAKE_Fortran_FLAGS="${ALLOPTS}" \
  -D CMAKE_INSTALL_LIBDIR=lib \
  -D PYMOD_INSTALL_LIBDIR="/python${PY_VER}/site-packages" \
  -D Python_EXECUTABLE=${PYTHON} \
  -D CMAKE_INSIST_FIND_PACKAGE_gau2grid=ON \
  -D MAX_AM_ERI=5 \
  -D CMAKE_INSIST_FIND_PACKAGE_Libint2=ON \
  -D CMAKE_INSIST_FIND_PACKAGE_pybind11=ON \
  -D CMAKE_INSIST_FIND_PACKAGE_Libxc=ON \
  -D CMAKE_INSIST_FIND_PACKAGE_qcelemental=ON \
  -D CMAKE_INSIST_FIND_PACKAGE_qcengine=ON \
  -D psi4_SKIP_ENABLE_Fortran=ON \
  -D ENABLE_dkh=ON \
  -D CMAKE_INSIST_FIND_PACKAGE_dkh=ON \
  -D ENABLE_OPENMP=ON \
  -D ENABLE_XHOST=OFF \
  -D ENABLE_GENERIC=OFF \
  -D LAPACK_LIBRARIES="${LAPACK_LIBRARIES}" \
  -D CMAKE_VERBOSE_MAKEFILE=OFF \
  -D CMAKE_PREFIX_PATH="${PREFIX}"

# Usual Conda compilers
#  -D CMAKE_C_COMPILER=${CC} \
#  -D CMAKE_CXX_COMPILER=${CXX} \
#  -D CMAKE_C_FLAGS="${CFLAGS}" \
#  -D CMAKE_CXX_FLAGS="${CXXFLAGS}" \
#  -D CMAKE_Fortran_COMPILER=${FC} \
#  -D CMAKE_Fortran_FLAGS="${FFLAGS}" \

# Classic Intel compilers
#  LD_PRELOAD=${BUILD_PREFIX}/lib/libstdc++.so \
#  -D CMAKE_C_COMPILER=icc \
#  -D CMAKE_CXX_COMPILER=icpc \
#  -D CMAKE_Fortran_COMPILER=ifort \
#  -D CMAKE_C_FLAGS="${ALLOPTS}" \
#  -D CMAKE_CXX_FLAGS="${ALLOPTS}" \
#  -D CMAKE_Fortran_FLAGS="${ALLOPTS}" \

# addons when ready for c-f
#  -D ENABLE_ambit=ON \
#  -D CMAKE_INSIST_FIND_PACKAGE_ambit=ON \
#  -D ENABLE_CheMPS2=ON \
#  -D CMAKE_INSIST_FIND_PACKAGE_CheMPS2=ON \
#  -D ENABLE_ecpint=ON \
#  -D CMAKE_INSIST_FIND_PACKAGE_ecpint=ON \
#  -D ENABLE_gdma=ON \
#  -D CMAKE_INSIST_FIND_PACKAGE_gdma=ON \
#  -D ENABLE_PCMSolver=ON \
#  -D CMAKE_INSIST_FIND_PACKAGE_PCMSolver=ON \
#  -D ENABLE_simint=ON \
#  -D SIMINT_VECTOR=sse \
#  -D CMAKE_INSIST_FIND_PACKAGE_simint=ON \

LD_PRELOAD=${BUILD_PREFIX}/lib/libstdc++.so \
cmake --build build --target install -j${CPU_COUNT}

#########
#    # remove conda-build-bound Cache file, to be replaced by psi4-dev
#    rm ${PREFIX}/share/cmake/psi4/psi4PluginCache.cmake
#
#    # generalize Targets.cmake files
#    sed -i "s|${BUILD_PREFIX}/${HOST}/sysroot/usr/lib/librt.so|-lrt|g" ${PREFIX}/share/cmake/TargetHDF5/TargetHDF5Targets.cmake
#    sed -i "s|${BUILD_PREFIX}/${HOST}/sysroot/usr/lib/libpthread.so|-lpthread|g" ${PREFIX}/share/cmake/TargetHDF5/TargetHDF5Targets.cmake
#    sed -i "s|${BUILD_PREFIX}/${HOST}/sysroot/usr/lib/libdl.so|-ldl|g" ${PREFIX}/share/cmake/TargetHDF5/TargetHDF5Targets.cmake
#    sed -i "s|${BUILD_PREFIX}/${HOST}/sysroot/usr/lib/libm.so|-lm|g" ${PREFIX}/share/cmake/TargetHDF5/TargetHDF5Targets.cmake
#    sed -i "s|;-Wl,-Bstatic;-lsvml;-Wl,-Bdynamic||g" ${PREFIX}/share/cmake/TargetLAPACK/TargetLAPACKTargets.cmake
#########

if [[ "${target_platform}" == "osx-arm64" ]]; then
    # tests don't run for this cross-compile, so this is best chance for inspection
    otool -L ${PREFIX}/lib/python${PY_VER}/site-packages/psi4/core*
fi

# pytest in conda testing stage
