mkdir build
cd build

if [ "$(uname)" == "Darwin" ]; then

    export DYLD_LIBRARY_PATH=${PREFIX}/lib:${DYLD_LIBRARY_PATH}
    rm ${PREFIX}/lib/libsqlite3*
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
        -DENABLE_CHEMPS2=OFF \
        -DENABLE_PCMSOLVER=OFF \
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
    make
    install_name_tool -change libpython2.7.dylib ${PREFIX}/lib/libpython2.7.dylib bin/psi4

else

    source /theoryfs2/common/software/intel2015/bin/compilervars.sh intel64
    export TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/nightly/glibc2.12

    cmake \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_Fortran_COMPILER=ifort \
        -DPYTHON_INTERPRETER=${PYTHON} \
        -DLIBINT_OPT_AM=6 \
        -DENABLE_STATIC_LINKING=ON \
        -DENABLE_XHOST=OFF \
        -DDETECT_EXTERNAL_STATIC=ON \
        -DENABLE_CONDA_DEST=ON \
        -DENABLE_PLUGINS=OFF \
        -DBOOST_INCLUDEDIR=${PREFIX}/include \
        -DBOOST_LIBRARYDIR=${PREFIX}/lib \
        -DENABLE_CHEMPS2=ON \
        -DCHEMPS2_ROOT=${PREFIX} \
        -DZLIB_ROOT=${PREFIX} \
        -DGSL_ROOT_DIR=${PREFIX} \
        -DHDF5_ROOT=${PREFIX} \
        -DENABLE_PCMSOLVER=ON \
        -DPCMSOLVER_ROOT=${PREFIX} \
        -DSPHINX_ROOT=${PREFIX} \
        -DCMAKE_BUILD_TYPE=release \
        -DLIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6" \
        -DBUILDNAME=LAB-RHEL7-gcc4.8.2-intel15.0.3-mkl-release-conda \
        -DSITE=gatech-conda \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        ${SRC_DIR}
    make -j3  #-j${CPU_COUNT}  # get incomplete build at full throttle
    make sphinxman
    make ghfeed
fi

make install

#    -DBUILD_CUSTOM_BOOST=ON \
