
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
    source /theoryfs2/common/software/intel2021/oneapi/setvars.sh --config="/theoryfs2/common/software/intel2021/oneapi/config-no-intelpython.txt" intel64
    set -x

    # allow more arguments to avoid the dreaded `x86_64-conda_cos6-linux-gnu-ld: Argument list too long` upon linking
    echo `getconf ARG_MAX`
    ulimit -s 65535
    echo `getconf ARG_MAX`

    # link against conda GCC
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -S ${SRC_DIR} \
        -B build \
        -G Ninja \
        -D CMAKE_INSTALL_PREFIX=${PREFIX} \
        -D CMAKE_BUILD_TYPE=Release \
        -D CMAKE_CXX_COMPILER=icpc \
        -D CMAKE_CXX_FLAGS="${ALLOPTS}" \
        -D CMAKE_INSTALL_LIBDIR=lib \
        -D BUILD_SHARED_LIBS=ON \
        -D LIBINT2_SHGAUSS_ORDERING=gaussian \
        -D LIBINT2_CARTGAUSS_ORDERING=standard \
        -D LIBINT2_SHELL_SET=standard \
        -D Eigen3_ROOT=${PREFIX} \
        -D LIBINT_GENERATE_FMA=ON \
        -D ENABLE_XHOST=OFF \
        -D REQUIRE_CXX_API=ON \
        -D REQUIRE_CXX_API_COMPILE=OFF \
        -D ENABLE_FORTRAN=OFF \
        -D BUILD_TESTING=ON
fi

        # l2cmake
        #-D BUILD_SHARED=ON \
        #-D BUILD_STATIC=OFF \
        #-D ERI3_PURE_SH=OFF \
        #-D ERI2_PURE_SH=OFF \
        #-D MPFR_ROOT=${PREFIX} \
        #-D BOOST_ROOT=${PREFIX} \
        #-D ENABLE_CXX11API=ON \

        #-DLIBINT2_SHGAUSS_ORDERING=gaussian \ usual psi4 gss
        #-DLIBINT2_SHGAUSS_ORDERING=standard \ future psi4 sss

# build & install & test
cmake --build build --target install -j${CPU_COUNT}


# This works for making a conda package out of a pre-built install
#
if [ "$(uname)" == "SpecialLinux" ]; then

PREBUILT=/psi/gits/libint2/install40

cp -pR ${PREBUILT}/* ${PREFIX}
cp ${PREFIX}/lib/pkgconfig/libint2.pc tmp0
sed "s|$PREBUILT|/opt/anaconda1anaconda2anaconda3|g" tmp0 > tmp1
cp tmp1 ${PREFIX}/lib/pkgconfig/libint2.pc

fi

