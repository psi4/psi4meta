# TOGGLE: clang/gcc for c-f
if [ "$(uname)" == "Darwin" ]; then
    ALLOPTS="${CFLAGS}"
fi
#if [ "$(uname)" == "Linux" ]; then
#    # revisit when c-f moves to gcc8
#    ALLOPTS="${CFLAGS} -D__GG_NO_PRAGMA"
#fi

# TOGGLE: intel for psi4
#if [ "$(uname)" == "Darwin" ]; then
#
#    # Intel atop conda Clang
#    ALLOPTS="-clang-name=${CLANG} -msse4.1 -axCORE-AVX2"
#    CC=icc
#fi
if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2019/bin/compilervars.sh intel64
    set -x

    # link against conda GCC
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"
    CC=icc
fi


${BUILD_PREFIX}/bin/cmake \
    -S${SRC_DIR} \
    -Bbuild \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=${CC} \
    -DCMAKE_C_FLAGS="${ALLOPTS}" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DPYMOD_INSTALL_LIBDIR="/python${PY_VER}/site-packages" \
    -DINSTALL_PYMOD=ON \
    -DBUILD_SHARED_LIBS=ON \
    -DENABLE_XHOST=OFF \
    -DPYTHON_EXECUTABLE=${PYTHON} \
    -DMAX_AM=8

cd build
make -j${CPU_COUNT}

make install

# tests outside build phase

# NOTES

# retired with 2.0
#        -DCARTESIAN_ORDER=row \
#        -DSPHERICAL_ORDER=gaussian \
