
if [ "$(uname)" == "Darwin" ]; then

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_COMPILER=${CLANGXX} \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS} ${OPTS}" \
        -DENABLE_XHOST=OFF

fi

if [ "$(uname)" == "Linux" ]; then

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
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}"
#needed?        -DENABLE_XHOST=OFF
fi

# build
cd build
make -j${CPU_COUNT}

# install
make install

# test
# no independent tests


# history
# -------

# original
#        -DCMAKE_CXX_FLAGS="${ALLOPTS} -static"

