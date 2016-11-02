
if [ "$(uname)" == "Darwin" ]; then

    export DYLD_LIBRARY_PATH=${PREFIX}/lib:${DYLD_LIBRARY_PATH}
    rm ${PREFIX}/lib/libsqlite3*

    # configure
    ${PREFIX}/bin/cmake \
        -DCMAKE_C_COMPILER=${PREFIX}/bin/gcc \
        -DCMAKE_CXX_COMPILER=${PREFIX}/bin/g++ \
        -DCMAKE_Fortran_COMPILER=${PREFIX}/bin/gfortran \
        -DCMAKE_OSX_DEPLOYMENT_TARGET='' \
        -DPYTHON_INTERPRETER=${PYTHON} \
        -DLIBINT_OPT_AM=6 \
        -DENABLE_STATIC_LINKING=OFF \
        -DENABLE_CONDA_DEST=ON \
        -DENABLE_PLUGINS=OFF \
        -DBUILD_CUSTOM_BOOST=ON \
        -DENABLE_CHEMPS2=ON \
        -DENABLE_PCMSOLVER=ON \
        -DENABLE_AMBIT=ON \
        -DZLIB_ROOT=${PREFIX} \
        -DHDF5_ROOT=${PREFIX} \
        -DCHEMPS2_ROOT=${PREFIX} \
        -DPCMSOLVER_ROOT=${PREFIX} \
        -DAMBIT_ROOT=${PREFIX} \
        -DCMAKE_BUILD_TYPE=debug \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DEXECUTABLE_SUFFIX= \
        -DENABLE_MPI=OFF \
        -DENABLE_SGI_MPT=OFF \
        -DENABLE_OMP=ON \
        -DENABLE_VECTORIZATION=OFF \
        -DENABLE_CSR=OFF \
        -DENABLE_SCALAPACK=OFF \
        -DENABLE_SCALASCA=OFF \
        -DENABLE_UNIT_TESTS=OFF \
        -DENABLE_CXX11_SUPPORT=ON \
        ${SRC_DIR}

    # build
    make
    make psi4so

    # install
    make install

    # test
    install_name_tool -change libpython2.7.dylib @rpath/libpython2.7.dylib ${PREFIX}/bin/psi4
    install_name_tool -change libpython2.7.dylib @rpath/libpython2.7.dylib ${PREFIX}/lib/python2.7/site-packages/psi4.so
    sed -i.bak "s|/opt/anaconda1anaconda2anaconda3|${PREFIX}|g" ${PREFIX}/share/psi4/python/pcm_placeholder.py
    DYLD_LIBRARY_PATH=${PREFIX}/lib:$DYLD_LIBRARY_PATH \
           PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib/python2.7/site-packages:$PYTHONPATH \
                 PATH=${PREFIX}/bin:$PATH \
        ctest -L quick

    # test debug line
    #DYLD_LIBRARY_PATH=/Users/loriab/linux/psi4-build/minicondadrive/envs/_build_placehold_placehold_pl/lib PATH=/Users/loriab/linux/psi4-build/minicondadrive/envs/_build_placehold_placehold_pl/bin:$PATH PYTHONPATH=/Users/loriab/linux/psi4-build/minicondadrive/envs/_build_placehold_placehold_pl/lib/python2.7/site-packages/:$PYTHONPATH
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    set -x
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64
    set +x

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
        -DPYMOD_INSTALL_LIBDIR="/python2.7/site-packages" \
        -DMAX_AM_ERI=6 \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DENABLE_gdma=ON \
        -DCMAKE_PREFIX_PATH="${PREFIX}" \
        -DENABLE_OPENMP=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON \
        -DLIBC_INTERJECT="${LIBC_INTERJECT}" \
        -DBUILDNAME=LAB-RHEL7-gcc5.2-intel16.0.3-mkl-release-conda \
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
         PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib/python2.7/site-packages:$PYTHONPATH \
               PATH=${PREFIX}/bin:$PATH \
      ctest -M Nightly -T Test -T Submit -j${CPU_COUNT} -L quick
      # TODO drop quick when all passing again

    # test-running env on psinet
    #LD_LIBRARY_PATH=/theoryfs2/ds/cdsgroup/miniconda/envs/_build_placehold_placehold_placehold_place/lib PYTHONPATH=/theoryfs2/ds/cdsgroup/miniconda/envs/_build_placehold_placehold_placehold_place/bin:/theoryfs2/ds/cdsgroup/miniconda/envs/_build_placehold_placehold_placehold_place/lib/python2.7/site-packages PATH=/theoryfs2/ds/cdsgroup/miniconda/envs/_build_placehold_placehold_placehold_place/bin:$PATH

fi

