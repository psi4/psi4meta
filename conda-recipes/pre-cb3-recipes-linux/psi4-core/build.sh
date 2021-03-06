
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

if [ "${PSI_BUILD_ISA}" == "sse41" ]; then
    ISA="-msse4.1"
elif [ "${PSI_BUILD_ISA}" == "avx2" ]; then
    ISA="-march=native"
fi


if [ "$(uname)" == "Darwin" ]; then

    if [ "${PSI_BUILD_CCFAM}" == "gnu" ]; then
        CC="${PREFIX}/bin/gcc"
        CXX="${PREFIX}/bin/g++"
        CCFLAGS=""
        CXXFLAGS=""
        OPENMP="ON"
    else
        CC="clang"
        CXX="clang++"
        CCFLAGS=""
        CXXFLAGS="-stdlib=libc++ "
        OPENMP="OFF"
    fi

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER="${CC}" \
        -DCMAKE_C_FLAGS="${CCFLAGS}${ISA}" \
        -DCMAKE_CXX_COMPILER="${CXX}" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}${ISA}" \
        -DCMAKE_Fortran_COMPILER=${PREFIX}/bin/gfortran \
        -DCMAKE_Fortran_FLAGS="${ISA}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_CheMPS2=ON \
        -DENABLE_dkh=ON \
        -DENABLE_libefp=ON \
        -DENABLE_erd=ON \
        -DENABLE_gdma=ON \
        -DENABLE_PCMSolver=ON \
        -DENABLE_simint=ON \
        -DSIMINT_VECTOR=sse \
        -DMAX_AM_ERI=6 \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}.dylib" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DCMAKE_PREFIX_PATH="${PREFIX}" \
        -DENABLE_OPENMP="${OPENMP}" \
        -DENABLE_XHOST=OFF \
        -DBUILDNAME="LAB-OSX-clang7.3.0-accelerate-py${CONDA_PY}-release-conda" \
        -DSITE=gatech-mac-conda \
        -DCMAKE_OSX_DEPLOYMENT_TARGET=''

        #-DLAPACK_LIBRARIES="/System/Library/Frameworks/Accelerate.framework/Accelerate" \
        #-DBLAS_LIBRARIES="/System/Library/Frameworks/Accelerate.framework/Accelerate"
        #-DENABLE_OPENMP=ON \

    # build
    cd build
    make -j${CPU_COUNT}
    #make VERBOSE=1

    # install
    make install

    # test (full suite too stressful for macpsinet)
    ctest -M Nightly -T Test -T Submit -j${CPU_COUNT} -L quick

    # notes
    #sed -i.bak "s|/opt/anaconda1anaconda2anaconda3|${PREFIX}|g" ${PREFIX}/share/psi4/python/pcm_placeholder.py
    #DYLD_LIBRARY_PATH=${PREFIX}/lib:$DYLD_LIBRARY_PATH \
    #       PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib/python2.7/site-packages:$PYTHONPATH \
    #             PATH=${PREFIX}/bin:$PATH \
fi

if [ "$(uname)" == "Linux" ]; then
    conda list
    echo $PYTHONPATH
    python -c "import sys; print(sys.path)"
    ls -l $SP_DIR

    # load Intel compilers and mkl
    set +x
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64
    set -x
    LAPACK_LIBRARIES="${PREFIX}/lib/libmkl_rt.so;${PREFIX}/lib/libiomp5.so;-fno-openmp;-lpthread;-lm;-ldl"
    LAPACK_INCLUDE_DIRS="${PREFIX}/include"

    # link against older libc for generic linux
    TLIBC=/home/psilocaluser/installs/glibc2.12
    LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6"

    # build multi-instruction-set library
    OPTS="-msse2 -axCORE-AVX2,AVX"

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_Fortran_COMPILER=ifort \
        -DCMAKE_C_FLAGS="${OPTS}" \
        -DCMAKE_CXX_FLAGS="${OPTS}" \
        -DCMAKE_Fortran_FLAGS="${OPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DMAX_AM_ERI=6 \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}.so" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DENABLE_CheMPS2=ON \
        -DENABLE_dkh=ON \
        -DENABLE_libefp=ON \
        -DENABLE_erd=ON \
        -DENABLE_gdma=ON \
        -DENABLE_PCMSolver=ON \
        -DENABLE_simint=ON \
        -DSIMINT_VECTOR=sse \
        -DCMAKE_PREFIX_PATH="${PREFIX}" \
        -DENABLE_OPENMP=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON \
        -DLAPACK_LIBRARIES="${LAPACK_LIBRARIES}" \
        -DLAPACK_INCLUDE_DIRS="${LAPACK_INCLUDE_DIRS}" \
        -DLIBC_INTERJECT="${LIBC_INTERJECT}" \
        -DBUILDNAME="LAB-RHEL7-gcc5.2-intel16.0.3-mkl-py${CONDA_PY}-release-conda" \
        -DSITE=gatech-conda \
        -DSPHINX_ROOT=${PREFIX}

        #-DENABLE_v2rdm_casscf=ON \
        #-DENABLE_snsmp2=ON \

    # build
    cd build
    make -j${CPU_COUNT}

    # install
    make install

    # test
    ctest -M Nightly -T Test -T Submit -j${CPU_COUNT}
fi

# docs build (1/6 nightly builds)
if [[ "$(uname)" == "Linux" ]] && [[ "${PSI_BUILD_DOCS}" == "1" ]] ; then
    make ghfeed
    make doxyman
    make sphinxman -j${CPU_COUNT}

    if [[ -d "doc/sphinxman/html" ]] && [[ -d "doc/sphinxman/feed" ]] && [[ -d "doc/doxygen/html" ]]; then
        # Upon sucessful docs build, tar 'em up and mv to dir to await beaming up to psicode.org

        cd doc/sphinxman
        mv html master
        tar -zcf cb-sphinxman.tar.gz master/
        mv -f cb-sphinxman.tar.gz /home/psilocaluser/gits/psi4meta/psicode_dropbox/

        tar -zcf cb-feed.tar.gz feed/
        mv -f cb-feed.tar.gz /home/psilocaluser/gits/psi4meta/psicode_dropbox/

        cd ../doxygen
        mv html doxymaster
        tar -zcf cb-doxyman.tar.gz doxymaster/
        mv -f cb-doxyman.tar.gz /home/psilocaluser/gits/psi4meta/psicode_dropbox/

        cd ../..
    fi
fi

    # notes
    #sed -i "s|/opt/anaconda1anaconda2anaconda3|${PREFIX}|g" ${PREFIX}/share/psi4/python/pcm_placeholder.py
    #LD_LIBRARY_PATH=${PREFIX}/lib:$LD_LIBRARY_PATH \
    #     PYTHONPATH=${PREFIX}/bin:${PREFIX}/lib${PYMOD_INSTALL_LIBDIR}:$PYTHONPATH \
    #           PATH=${PREFIX}/bin:$PATH \
