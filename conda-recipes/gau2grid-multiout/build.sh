
if [ "$(uname)" == "Darwin" ]; then

    # Intel atop conda Clang
    CMAKE_C_FLAGS="-clang-name=${CLANG} -msse4.1 -axCORE-AVX2"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_C_FLAGS="${CMAKE_C_FLAGS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="/python${PY_VER}/site-packages" \
        -DINSTALL_PYMOD=ON \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=OFF \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DMAX_AM=8
fi


if [ "$(uname)" == "Linux" ]; then

# to practice c-f
#  * ldd -r -u need && return 0 toggled
#  * not Intel compilers
#  * source/path: ../../../gau2grid
#    ALLOPTS="-gnu-prefix=${HOST}-"
#        -DCMAKE_C_COMPILER=${CC} \
#        -DCMAKE_C_FLAGS="${CFLAGS}" \

    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2018/bin/compilervars.sh intel64
    set -x

    # link against conda GCC
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_C_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="/python${PY_VER}/site-packages" \
        -DINSTALL_PYMOD=ON \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DMAX_AM=8
fi

# build
cd build
make -j${CPU_COUNT}

# install
make install

# test
# outside build phase

# NOTES

# retired with 2.0
#        -DCARTESIAN_ORDER=row \
#        -DSPHERICAL_ORDER=gaussian \
