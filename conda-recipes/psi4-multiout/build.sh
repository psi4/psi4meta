
if [ "$(uname)" == "Darwin" ]; then

    #ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"
    #ALLOPTS="-clang-name=${CLANG} -clangxx-name=${CLANGXX} -stdlib=libc++ -I${PREFIX}/include/c++/v1 ${OPTS}"
    # link against conda Clang
    ALLOPTS="-clang-name=${CLANG} ${OPTS}"
    ALLOPTSCXX="-clang-name=${CLANG} -clangxx-name=${CLANGXX} -stdlib=libc++ -I${PREFIX}/include/c++/v1 ${OPTS} -mmacosx-version-min=10.9"


    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_Fortran_COMPILER=${FC} \
        -DCMAKE_C_FLAGS="${ALLOPTS}" \
        -DCMAKE_CXX_FLAGS="${ALLOPTSCXX}" \
        -DCMAKE_Fortran_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DMAX_AM_ERI=${MAX_AM_ERI} \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}${SHLIB_EXT}" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DCMAKE_PREFIX_PATH="${PREFIX}" \
        -DCMAKE_INSIST_FIND_PACKAGE_gau2grid=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_Libint=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_pybind11=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_Libxc=ON \
        -DENABLE_OPENMP=ON \
        -DENABLE_XHOST=OFF \
        -DBUILDNAME="LAB-OSX-clang4.0.1-intel18.0.2-mkl-py${CONDA_PY}-release-conda" \
        -DSITE=gatech-mac-conda \
        -DCMAKE_OSX_DEPLOYMENT_TARGET=''

#        -DBUILD_SHARED_LIBS=ON \
#        -DENABLE_CheMPS2=ON \
#        -DENABLE_dkh=ON \
#        -DENABLE_libefp=ON \
#        -DENABLE_erd=ON \
#        -DENABLE_gdma=ON \
#        -DENABLE_PCMSolver=ON \
#        -DENABLE_simint=ON \
#        -DSIMINT_VECTOR=sse \

    # build
    cd build
    make -j${CPU_COUNT}

    # install
    make install

    # test (full suite too stressful for macpsinet)
    ctest -M Nightly -T Test -T Submit -j${CPU_COUNT} -L quick

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
        -DCMAKE_Fortran_COMPILER=ifort \
        -DCMAKE_C_FLAGS="${ALLOPTS}" \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DCMAKE_Fortran_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DMAX_AM_ERI=${MAX_AM_ERI} \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}.so" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DCMAKE_PREFIX_PATH="${PREFIX}" \
        -DCMAKE_INSIST_FIND_PACKAGE_gau2grid=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_Libint=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_pybind11=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_Libxc=ON \
        -DENABLE_CheMPS2=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_CheMPS2=ON \
        -DENABLE_dkh=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_dkh=ON \
        -DENABLE_libefp=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_libefp=ON \
        -DENABLE_gdma=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_gdma=ON \
        -DENABLE_PCMSolver=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_PCMSolver=ON \
        -DENABLE_OPENMP=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=OFF \
        -DLAPACK_LIBRARIES="${LAPACK_INTERJECT}" \
        -DBUILDNAME="LAB-RHEL7-gcc7.2-intel18.0.2-mkl-py${CONDA_PY}-release-conda" \
        -DSITE="gatech-conda" \
        -DSPHINX_ROOT=${PREFIX}

        #-DENABLE_erd=ON \
        #-DCMAKE_INSIST_FIND_PACKAGE_erd=ON \
        #-DENABLE_simint=ON \
        #-DSIMINT_VECTOR=sse \
        #-DCMAKE_INSIST_FIND_PACKAGE_simint=ON \
        #-DCMAKE_INSIST_FIND_PACKAGE_ambit=ON \
        #-DCMAKE_INSIST_FIND_PACKAGE_GTFock=ON \

        #-DENABLE_v2rdm_casscf=ON \
        #-DCMAKE_INSIST_FIND_PACKAGE_v2rdm_casscf=ON \
        #-DENABLE_snsmp2=ON \
        #-DCMAKE_INSIST_FIND_PACKAGE_snsmp2=ON \

    # build
    cd build
    make -j${CPU_COUNT}

    # install
    make install

    # test
    # * full PREFIX is too long for shebang (in bin/psi4 tests), so use env python just for tests
    mv stage/${PREFIX}/bin/psi4 stage/${PREFIX}/bin/psi4_reserve
    echo "#! /usr/bin/env python" > stage/${PREFIX}/bin/psi4
    cat stage/${PREFIX}/bin/psi4_reserve >> stage/${PREFIX}/bin/psi4
    chmod u+x stage/${PREFIX}/bin/psi4

    stage/${PREFIX}/bin/psi4 ../tests/tu1-h2o-energy/input.dat
    ctest -M Nightly -T Test -T Submit -j${CPU_COUNT} -L quick

    mv -f stage/${PREFIX}/bin/psi4_reserve stage/${PREFIX}/bin/psi4
fi

# NOTES
# -----

    #sed -i "s|/opt/anaconda1anaconda2anaconda3|${PREFIX}|g" ${PREFIX}/share/psi4/python/pcm_placeholder.py
    #LD_LIBRARY_PATH=${PREFIX}/lib:$LD_LIBRARY_PATH \
    #     PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib${PYMOD_INSTALL_LIBDIR}:$PYTHONPATH \
    #           PATH=${PREFIX}/bin:$PATH \

    # * HOST=x86_64-conda_cos6-linux-gnu
    #OPTS="-gnu-prefix=x86_64-conda_cos6-linux-gnu- -msse2 -axCORE-AVX2,AVX"

    #sed -i.bak "s|/opt/anaconda1anaconda2anaconda3|${PREFIX}|g" ${PREFIX}/share/psi4/python/pcm_placeholder.py
    #DYLD_LIBRARY_PATH=${PREFIX}/lib:$DYLD_LIBRARY_PATH \
    #       PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib/python2.7/site-packages:$PYTHONPATH \
    #             PATH=${PREFIX}/bin:$PATH \
