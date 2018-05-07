
if [ "$(uname)" == "Linux" ]; then

    # link against conda MKL & GCC
    # * since libefp uses mkl, makes sense to do so here, too
    LAPACK_INTERJECT="${PREFIX}/lib/libmkl_rt.so"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_C_COMPILER=${CC} \
        -DCMAKE_CXX_COMPILER=${CXX} \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DMAX_AM_ERI=5 \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}.so" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DCMAKE_PREFIX_PATH="${PREFIX}" \
        -DCMAKE_INSIST_FIND_PACKAGE_gau2grid=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_Libint=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_pybind11=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_Libxc=ON \
        -DENABLE_libefp=ON \
        -DCMAKE_INSIST_FIND_PACKAGE_libefp=ON \
        -DENABLE_OPENMP=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=OFF \
        -DLAPACK_LIBRARIES="${LAPACK_INTERJECT}" \
        -DSPHINX_ROOT=${PREFIX}

    # build
    cd build
    make -j${CPU_COUNT}

    # install psi4
    make install

    # can't use full PREFIX or workaround b/c tests and make/install intertwined so use shorter prefix

    # test
    stage/${PREFIX}/bin/psi4 ../tests/tu1-h2o-energy/input.dat
    ctest -j${CPU_COUNT} -L smoke

    # docs build
    make ghfeed
    make doxyman
    make sphinxman -j${CPU_COUNT}

    # install docs
    make install

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
