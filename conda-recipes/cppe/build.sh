
#    # load Intel compilers
#    set +x
#    source /theoryfs2/common/software/intel2018/bin/compilervars.sh intel64
#    set -x
# error with Intel 2018.3, 2019.4
#
#    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

# configure
${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_COMPILER=${CXX} \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -DBUILD_SHARED_LIBS=ON \
        -DINSTALL_DEVEL_HEADERS=OFF \
        -DENABLE_OPENMP=OFF \
        -DENABLE_XHOST=OFF \
        -DPYTHON_EXECUTABLE="${PYTHON}" \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}${SHLIB_EXT}" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DENABLE_PYTHON_INTERFACE=ON \
        -Dpybind11_DIR="${PREFIX}/share/cmake/pybind11" \
        -DCMAKE_INSIST_FIND_PACKAGE_pybind11=ON \
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DCMAKE_PREFIX_PATH="${PREFIX}"

# TODO OpenMP is off b/c getting gomp

# build
cd build
make -j${CPU_COUNT}

# install
make install
