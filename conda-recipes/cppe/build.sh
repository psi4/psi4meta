
#    # load Intel compilers
#    set +x
#    source /theoryfs2/common/software/intel2018/bin/compilervars.sh intel64
#    set -x
# error with Intel 2018.3, 2019.4
#
#    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

# configure
${BUILD_PREFIX}/bin/cmake \
        -S${SRC_DIR} \
        -Bbuild \
        -GNinja \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_COMPILER=${CXX} \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -DBUILD_SHARED_LIBS=ON \
        -DINSTALL_DEVEL_HEADERS=OFF \
        -DENABLE_OPENMP=OFF \
        -DENABLE_XHOST=OFF \
        -DPYTHON_EXECUTABLE="${PYTHON}" \
        -DPYTHON_LIBRARY="${PREFIX}/lib/libpython${PY_VER}m${SHLIB_EXT}" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/python${PY_VER}m" \
        -DENABLE_PYTHON_INTERFACE=ON \
        -Dpybind11_DIR="${PREFIX}/share/cmake/pybind11" \
        -DCMAKE_INSIST_FIND_PACKAGE_pybind11=ON \
        -DPYMOD_INSTALL_LIBDIR="/python${PY_VER}/site-packages" \
        -DCMAKE_PREFIX_PATH="${PREFIX}"

# TODO OpenMP is off b/c getting gomp

# build
cmake --build build -- -j${CPU_COUNT}

# install
cmake --build build --target install
