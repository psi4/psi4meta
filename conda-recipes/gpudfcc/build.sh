
psi4 --version


if [ "$(uname)" == "Darwin" ]; then
    echo "Hello Mac"
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    # * NOTE 2017.0.4 --- 2018 does not make nvcc happy!
    set +x
    source /theoryfs2/common/software/intel2017/bin/compilervars.sh intel64
    set -x

    # load CUDA compilers
    CUDA=/theoryfs2/ds/cdsgroup/psi4-install/cuda-9.0

    # link against conda GCC
    # * NOTE GCC=5.4, as 7.2 does not make nvcc happy
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
        -DCMAKE_CUDA_COMPILER="${CUDA}/bin/nvcc" \
        -DCUDA_TOOLKIT_ROOT_DIR="${CUDA}" \
        -DCUDA_USE_STATIC_CUDA_RUNTIME=OFF \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_XHOST=OFF
fi

# build
make -j${CPU_COUNT}

# install
make install

if [ "$(uname)" == "Linux" ]; then
    # squash local toolkit link
    sed -i "s|${CUDA}/lib64/libcudart.so;||g" ${PREFIX}/share/cmake/gpu_dfcc/gpu_dfccTargets.cmake
fi

# NOTES
# -----
