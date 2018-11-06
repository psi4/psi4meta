
# selectors in meta.yaml constrain to Linux, Py3 only

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
    -DCMAKE_CXX_FLAGS="--coverage" \
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
    -DCMAKE_INSIST_FIND_PACKAGE_qcelemental=ON \
    -DENABLE_libefp=ON \
    -DCMAKE_INSIST_FIND_PACKAGE_libefp=ON \
    -DENABLE_OPENMP=ON \
    -DENABLE_XHOST=OFF \
    -DENABLE_GENERIC=OFF \
    -DLAPACK_LIBRARIES="${LAPACK_INTERJECT}" \
    -DLAPACK_INCLUDE_DIRS="${PREFIX}/include" \
    -DSPHINX_ROOT=${PREFIX}

# build
cd build
make -j${CPU_COUNT}

# install psi4
make install

# can't use full PREFIX or workaround b/c tests and make/install intertwined so use shorter prefix

# test
stage/bin/psi4 ../tests/tu1-h2o-energy/input.dat

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

# test and coverage
# * run_coverage.py runs psi4 tests in parallel
#   * `coverage run` makes `.coverage.<more_random_info>` files for each test with py-side line cov info
#   * `coverage combine` summarizes all the above into `.coverage` for py-side line cov info
#   * `coverage report` just prints a nice report
# * codecov.io/bash runs the c-side analysis and uploads the two (py, c) reports to codecov.io
#   * pycoverage step uploads the .coverage report (turn off with -X pycoverage)
#   * gcov step turns .gcda/.gcno info in build filesys into .gcov reports for each c-side file with line cov info (turn off with -X gcov)
#   * -x uses exactly the corresponding `gcov` executable to the `gcc` compiler
#   * -r sets the record straight on what repository (running w/i conda-build gets confused and issues the followig error otherwise)
#        HTTP 400 slug must match pattern ^[\w\-\.]{1,255}\/[\w\-\.]{1,255}$
#   * -t gives the codecov token, since we're not uploading from travis, a verified source
echo $PATH
${PYTHON} ${RECIPE_DIR}/run_coverage.py
TOKEN=$(cat ${RECIPE_DIR}/token-codecov)
bash <(curl -s https://codecov.io/bash) -x $HOST-gcov -r psi4/psi4 -t ${TOKEN}

