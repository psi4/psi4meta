
psi4 --version
#git describe

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    set +x
    source /theoryfs2/common/software/intel2019/bin/compilervars.sh intel64
    set -x

    # suppress Intel Fortran libs
    #LIBC_INTERJECT="-liomp5;-Wl,-Bstatic;-lifport;-lifcoremt_pic;-Wl,-Bdynamic"

    # link against conda GCC
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -B. \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_C_FLAGS="${ALLOPTS}" \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=OFF \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/libpython${PY_VER}m${SHLIB_EXT}" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/python${PY_VER}m" \
        -DLIBC_INTERJECT=${LIBC_INTERJECT}

# python trio isn't generally necessary. revisit after psi4-dev ready
fi

# build
make -j${CPU_COUNT}
echo built

# install
echo "${SP_DIR}"
ls -l ${SP_DIR}
#echo ${PREFIX}/lib/python${PY_VER}/site-packages
#ls -l ${PREFIX}/lib/python${PY_VER}/site-packages
mkdir -p ${SP_DIR}/miniforte
cp -R __init__.py ${SP_DIR}/miniforte
cp -R mf.py ${SP_DIR}/miniforte
cp -R miniforte.cpython-38-x86_64-linux-gnu.so ${SP_DIR}/miniforte
ls -l ${SP_DIR}/miniforte
echo installed

