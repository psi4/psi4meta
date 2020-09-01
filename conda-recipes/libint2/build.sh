
if [ "$(uname)" == "Darwin" ]; then

    # link against conda Clang
#    # * -fno-exceptions squashes `___gxx_personality_v0` symbol and thus libc++ dependence
#    ALLOPTS="-clang-name=${CLANG} ${OPTS} -fno-exceptions"
#    ALLOPTSCXX="-clang-name=${CLANG} -clangxx-name=${CLANGXX} -stdlib=libc++ -I${PREFIX}/include/c++/v1 ${OPTS} -fno-exceptions -mmacosx-version-min=10.9"
    ALLOPTS="-clang-name=${CLANG} -clangxx-name=${CLANGXX} -stdlib=libc++ -I${PREFIX}/include/c++/v1 ${OPTS} -mmacosx-version-min=10.9"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -GNinja \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DBUILD_SHARED=ON \
        -DBUILD_STATIC=OFF \
        -DLIBINT2_SHGAUSS_ORDERING=gaussian \
        -DLIBINT2_CARTGAUSS_ORDERING=standard \
        -DLIBINT2_SHELL_SET=standard \
        -DENABLE_ERI=2 \
        -DENABLE_ERI3=2 \
        -DENABLE_ERI2=2 \
        -DWITH_ERI_MAX_AM:STRING="3;3;3" \
        -DWITH_ERI3_MAX_AM=4 \
        -DWITH_ERI2_MAX_AM=4 \
        -DMPFR_ROOT=${PREFIX} \
        -DBOOST_ROOT=${PREFIX} \
        -DEigen3_ROOT=${PREFIX}
fi
        #-DWITH_ERI_MAX_AM:STRING="5;5;5" \
        #-DWITH_ERI3_MAX_AM=6 \
        #-DWITH_ERI2_MAX_AM=6 \

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2019/bin/compilervars.sh intel64
    set -x

    # link against conda GCC
    # * lang defined as CXX in CMake (file extension reasons), so $OPTS brings
    #   libstdc++, hence the ENABLE_GENERIC=ON
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -GNinja \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DBUILD_SHARED=ON \
        -DBUILD_STATIC=OFF \
        -DLIBINT2_SHGAUSS_ORDERING=gaussian \
        -DLIBINT2_CARTGAUSS_ORDERING=standard \
        -DLIBINT2_SHELL_SET=standard \
        -DENABLE_ERI=2 \
        -DENABLE_ERI3=2 \
        -DENABLE_ERI2=2 \
        -DWITH_ERI_MAX_AM:STRING="5;5;5" \
        -DWITH_ERI3_MAX_AM=6 \
        -DWITH_ERI2_MAX_AM=6 \
        -DMPFR_ROOT=${PREFIX} \
        -DBOOST_ROOT=${PREFIX} \
        -DEigen3_ROOT=${PREFIX}

        #-DEigen3_DIR=${PREFIX}/share/eigen3/cmake/
        #-DERI3_PURE_SH=ON \
        #-DERI2_PURE_SH=ON \
fi

# build
cd build
cmake --build . -j${CPU_COUNT}

# install
cmake --build . --target install

# test
# Coming!
