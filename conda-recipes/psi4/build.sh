
if [ "${CONDA_PY}" == "27" ]; then
    PYMOD_INSTALL_LIBDIR="/python2.7/site-packages"
    PY_ABBR="python2.7"
elif [ "${CONDA_PY}" == "35" ]; then
    PYMOD_INSTALL_LIBDIR="/python3.5/site-packages"
    PY_ABBR="python3.5m"
fi

if [ "$(uname)" == "Darwin" ]; then

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_CXX_FLAGS="-stdlib=libc++" \
        -DCMAKE_Fortran_COMPILER=${PREFIX}/bin/gfortran \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_CheMPS2=ON \
        -DENABLE_libefp=ON \
        -DENABLE_erd=ON \
        -DENABLE_gdma=ON \
        -DENABLE_PCMSolver=ON \
        -DMAX_AM_ERI=6 \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}.dylib" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DCMAKE_PREFIX_PATH="${PREFIX}" \
        -DBUILDNAME="LAB-OSX-clang7.3.0-accelerate-py${CONDA_PY}-release-conda" \
        -DSITE=gatech-mac-conda \
        -DCMAKE_OSX_DEPLOYMENT_TARGET=''

        #-DLAPACK_LIBRARIES="/System/Library/Frameworks/Accelerate.framework/Accelerate" \
        #-DBLAS_LIBRARIES="/System/Library/Frameworks/Accelerate.framework/Accelerate"
        #-DENABLE_OPENMP=ON \

    # build
    cd build
    make -j${CPU_COUNT}

    # install
    make install

    # test
    #install_name_tool -change libpython2.7.dylib @rpath/libpython2.7.dylib ${PREFIX}/bin/psi4
    #install_name_tool -change libpython2.7.dylib @rpath/libpython2.7.dylib ${PREFIX}/lib/python2.7/site-packages/psi4.so
    #sed -i.bak "s|/opt/anaconda1anaconda2anaconda3|${PREFIX}|g" ${PREFIX}/share/psi4/python/pcm_placeholder.py
    #DYLD_LIBRARY_PATH=${PREFIX}/lib:$DYLD_LIBRARY_PATH \
    #       PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib/python2.7/site-packages:$PYTHONPATH \
    #             PATH=${PREFIX}/bin:$PATH \
    ctest -M Nightly -T Test -T Submit -j${CPU_COUNT} -L quick
      # TODO drop quick when all passing again
        #ctest -L quick

    # test debug line
    #DYLD_LIBRARY_PATH=/Users/loriab/linux/psi4-build/minicondadrive/envs/_build_placehold_placehold_pl/lib PATH=/Users/loriab/linux/psi4-build/minicondadrive/envs/_build_placehold_placehold_pl/bin:$PATH PYTHONPATH=/Users/loriab/linux/psi4-build/minicondadrive/envs/_build_placehold_placehold_pl/lib/python2.7/site-packages/:$PYTHONPATH
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    set +x
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64
    set -x

    # link against older libc for generic linux
    TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/nightly/glibc2.12
    LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6"

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
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DMAX_AM_ERI=6 \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}.so" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DENABLE_CheMPS2=ON \
        -DENABLE_libefp=ON \
        -DENABLE_erd=ON \
        -DENABLE_gdma=ON \
        -DENABLE_PCMSolver=ON \
        -DCMAKE_PREFIX_PATH="${PREFIX}" \
        -DENABLE_OPENMP=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON \
        -DLIBC_INTERJECT="${LIBC_INTERJECT}" \
        -DBUILDNAME="LAB-RHEL7-gcc5.2-intel16.0.3-mkl-py${CONDA_PY}-release-conda" \
        -DSITE=gatech-conda \
        -DSPHINX_ROOT=${PREFIX}

        #-D LAPACK_INTERJECT=${LAPACK_INTERJECT}
                    #-DLAPACKBLAS_LIBRARIES:LIST=${LAPACKBLAS_LIBRARIES}
                    #-DLAPACKBLAS_INCLUDE_DIRS:LIST=${LAPACKBLAS_INCLUDE_DIRS}

    # build
    cd build
    make -j${CPU_COUNT}
    make ghfeed
    make sphinxman -j${CPU_COUNT}

    # install
    make install

    # test
    #sed -i "s|/opt/anaconda1anaconda2anaconda3|${PREFIX}|g" ${PREFIX}/share/psi4/python/pcm_placeholder.py
    LD_LIBRARY_PATH=${PREFIX}/lib:$LD_LIBRARY_PATH \
         PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib${PYMOD_INSTALL_LIBDIR}:$PYTHONPATH \
               PATH=${PREFIX}/bin:$PATH \
      ctest -M Nightly -T Test -T Submit -j${CPU_COUNT} -L quick
      # TODO drop quick when all passing again
fi

