set -ex

if [ "$(uname)" == "Darwin" ]; then

    # load Intel compilers
    source /opt/intel/oneapi/setvars.sh

    # Intel atop conda Clang
    ALLOPTS="-clang-name=${CLANG} -msse4.1 -axCORE-AVX2"

    # for FortranCInterface
    #CMAKE_Fortran_FLAGS="${FFLAGS} -L${CONDA_BUILD_SYSROOT}/usr/lib/system/ ${OPTS} -O0"
fi


if [ "$(uname)" == "Linux" ]; then

    # Intel multiarch
    OPTS="-msse2 -axCORE-AVX512,CORE-AVX2,AVX -Wl,--as-needed -static-intel -wd10237"

    # load Intel compilers
    set +x
#    LATEST_VERSION=$(ls -1 /opt/intel/oneapi/compiler/ | grep -v latest | sort | tail -1)
#    source /opt/intel/oneapi/compiler/"$LATEST_VERSION"/env/vars.sh intel64
    source /theoryfs2/common/software/intel2021/oneapi/setvars.sh --config="/theoryfs2/common/software/intel2021/oneapi/config-no-intelpython.txt" intel64
#    source /theoryfs2/common/software/intel2019/compilers_and_libraries_2019.4.243/linux/bin/compilervars.sh intel64
    set -x

    # link against conda GCC
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"
fi

export FC=ifort
export CC=icc

# allows meson to find conda mkl_rt
export LIBRARY_PATH=${PREFIX}/lib

# configure
meson_options_linux=(
   "--prefix=${PREFIX}"
   "--libdir=lib"
   "--buildtype=release"
   "--warnlevel=0"
   "-Dpython=true"
   "-Dc_args=-qopenmp"
   "-Dfortran_args=-qopenmp"
   "-Dlapack=mkl-rt"
   "-Dfortran_link_args=-liomp5 -Wl,-Bstatic -lifport -lifcoremt_pic -limf -lsvml -lirc -lsvml -lirc_s -Wl,-Bdynamic"
   "-Dc_link_args=-liomp5 -static-intel"
   ".."
)
meson_options_mac=(
   "--prefix=${PREFIX}"
   "--libdir=lib"
   "--buildtype=release"
   "--warnlevel=0"
   "--errorlogs"
   "-Dpython=true"
   "-Dc_args=-qopenmp"
   "-Dfortran_args=-qopenmp"
   "-Dlapack=mkl-rt"
   "-Dfortran_link_args=-liomp5"
   "-Dc_link_args=-liomp5 -static-intel"
   ".."
)

mkdir -p _build
pushd _build

# build and test
if [[ "$(uname)" = Darwin ]]; then
#    # Hack around issue, see contents of fake-bin/cc1 for an explanation
#    PATH=${PATH}:${RECIPE_DIR}/fake-bin meson "${meson_options[@]}"
    meson "${meson_options_mac[@]}"
#    DYLD_LIBRARY_PATH=${PREFIX}/lib:${DYLD_LIBRARY_PATH}
else
    meson "${meson_options_linux[@]}"
fi

#cat $SRC_DIR/_build/meson-logs/meson-log.txt

# Linux install
ninja test install

# Python install
ls -l python/dftd4
cp python/dftd4/_libdftd4.*so ../python/dftd4
popd
cp assets/parameters.toml python/dftd4/
pushd python
"$PYTHON" -m pip install . --no-deps -vvv
popd

