
if [ "$(uname)" == "Darwin" ]; then

    # link against conda Clang
#    # * -fno-exceptions squashes `___gxx_personality_v0` symbol and thus libc++ dependence
#    ALLOPTS="-clang-name=${CLANG} ${OPTS} -fno-exceptions"
#    ALLOPTSCXX="-clang-name=${CLANG} -clangxx-name=${CLANGXX} -stdlib=libc++ -I${PREFIX}/include/c++/v1 ${OPTS} -fno-exceptions -mmacosx-version-min=10.9"
#    ALLOPTS="-clang-name=${CLANG} -clangxx-name=${CLANGXX} -stdlib=libc++ -I${PREFIX}/include/c++/v1 ${OPTS} -mmacosx-version-min=10.9"
#        -DCMAKE_CXX_COMPILER=icpc \
#        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -GNinja \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_COMPILER=${CLANGXX} \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DBUILD_SHARED=ON \
        -DBUILD_STATIC=OFF \
        -DLIBINT2_SHGAUSS_ORDERING=gaussian \
        -DLIBINT2_CARTGAUSS_ORDERING=standard \
        -DLIBINT2_SHELL_SET=standard \
        -DMPFR_ROOT=${PREFIX} \
        -DBOOST_ROOT=${PREFIX} \
        -DEigen3_ROOT=${PREFIX} \
        -DENABLE_FORTRAN=OFF \
        -DBUILD_TESTING=ON
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2019/bin/compilervars.sh intel64
    set -x

    # allow more arguments to avoid the dreaded `x86_64-conda_cos6-linux-gnu-ld: Argument list too long` upon linking
    echo `getconf ARG_MAX`
    ulimit -s 65535
    echo `getconf ARG_MAX`

    # link against conda GCC
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
        -DERI3_PURE_SH=OFF \
        -DERI2_PURE_SH=OFF \
        -DMPFR_ROOT=${PREFIX} \
        -DBOOST_ROOT=${PREFIX} \
        -DEigen3_ROOT=${PREFIX} \
        -DLIBINT_GENERATE_FMA=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_CXX11API=ON \
        -DENABLE_FORTRAN=OFF \
        -DBUILD_TESTING=ON
fi

# build & install & test
cd build
cmake --build . --target install -j${CPU_COUNT}


# This works for making a conda package out of a pre-built install
#
if [ "$(uname)" == "SpecialLinux" ]; then

PREBUILT=/psi/gits/libint2/install40

cp -pR ${PREBUILT}/* ${PREFIX}
cp ${PREFIX}/lib/pkgconfig/libint2.pc tmp0
sed "s|$PREBUILT|/opt/anaconda1anaconda2anaconda3|g" tmp0 > tmp1
cp tmp1 ${PREFIX}/lib/pkgconfig/libint2.pc

fi

