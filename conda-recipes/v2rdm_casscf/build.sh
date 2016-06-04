# universal includes
INCLUDES="-Iinclude -I${PREFIX}/include/ -I${PREFIX}/include/psi4 -I${PREFIX}/include/psi4/lib -I${PREFIX}/include/python2.7/ "

if [ "$(uname)" == "Darwin" ]; then

    # conda gnu compilers
    F90="${PREFIX}/bin/gfortran"
    CXX="${PREFIX}/bin/g++"

    # copy flags, defs, includes from watered-down conda plugin version
    CXXFLAGS="-DRESTRICT=__restrict__ -Xlinker -dynamic -fPIC -std=c++11 -fopenmp -O0 -g3 -DDEBUG -Wall -Wextra -Winit-self -Woverloaded-virtual -Wuninitialized -Wmissing-declarations -Wwrite-strings"
    CXXDEFS="-DHAVE_GDMA -DHAVE_DKH -DHAVE_MM_MALLOC_H -DHAVE_SYSTEM_NATIVE_LAPACK -DHAVE_SYSTEM_NATIVE_BLAS -DHAS_CXX11_VARIADIC_TEMPLATES -DHAS_CXX11_STATIC_ASSERT -DHAS_CXX11_SIZEOF_MEMBER -DHAS_CXX11_RVALUE_REFERENCES -DHAS_CXX11_NULLPTR -DHAS_CXX11_LONG_LONG -DHAS_CXX11_LAMBDA -DHAS_CXX11_INITIALIZER_LIST -DHAS_CXX11_DECLTYPE -DHAS_CXX11_CSTDINT_H -DHAS_CXX11_CONSTEXPR -DHAS_CXX11_AUTO_RET_TYPE -DHAS_CXX11_AUTO -DHAS_CXX11_FUNC -DHAS_CXX11 -DVAR_MFDS -DSYS_DARWIN -DUSE_FCMANGLE_H"
    LDFLAGS="-Wl,-search_paths_first -Wl,-headerpad_max_install_names"

    FLIBS=" "
    FFLAGS="-O2"
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64
    F90=ifort
    CXX=icpc
    
    # link against older libc for generic linux
    export TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/nightly/glibc2.12
    LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6"
    LDFLAGS="-Wl,--as-needed -static-libstdc++ -static-libgcc -static-intel -wd10237 -static-intel ${LIBC_INTERJECT}"
    
    # copy flags, defs, includes from proper linux build, not watered-down conda plugin version
    CXXFLAGS="-DRESTRICT=__restrict__ -Xlinker -export-dynamic -fPIC -std=c++11 -qopenmp -O3 -DNDEBUG"  # -no-prec-div is deadly to tests/v2rdm1
    CXXDEFS="-DHAVE_GDMA -DHAVE_DKH -DHAVE_MM_MALLOC_H -DHAVE_MKL_LAPACK -DHAVE_MKL_BLAS -DHAS_CXX11_VARIADIC_TEMPLATES -DHAS_CXX11_STATIC_ASSERT -DHAS_CXX11_SIZEOF_MEMBER -DHAS_CXX11_RVALUE_REFERENCES -DHAS_CXX11_NULLPTR -DHAS_CXX11_LONG_LONG -DHAS_CXX11_LAMBDA -DHAS_CXX11_INITIALIZER_LIST -DHAS_CXX11_DECLTYPE -DHAS_CXX11_CSTDINT_H -DHAS_CXX11_CONSTEXPR -DHAS_CXX11_AUTO_RET_TYPE -DHAS_CXX11_AUTO -DHAS_CXX11_FUNC -DHAS_CXX11 -DSYS_LINUX -DUSE_FCMANGLE_H"

    FLIBS="-Wl,-Bstatic -Wl,--whole-archive -lifport -lifcore_pic -Wl,--no-whole-archive -Wl,-Bdynamic"
    FFLAGS="-heap-arrays -openmp -O2 -fPIC -DOMP"
fi

# make (in subdir so plugin gets correct name)
mkdir v2rdm_casscf
cd v2rdm_casscf
cp -p ../*.h .
cp -p ../*.cc .
cp -p ../*.F90* .
cp -p ../configure .
./configure \
    --prefix=${PREFIX} \
    --cxx=${CXX} \
    --cxxdefs="${CXXDEFS}" \
    --cxxflags"=${CXXFLAGS}" \
    --ldflags="${LDFLAGS}" \
    --includes="${INCLUDES}" \
    --python=${PYTHON} \
    --fc=${F90} \
    --flibs="${FLIBS}" \
    --fflags="${FFLAGS}"
make
mv v2rdm_casscf.so ..
cd ..

# install
INSTALLSITE="${PREFIX}/lib/python2.7/site-packages/v2rdm_casscf/"
mkdir -p ${INSTALLSITE}
cp README.md ${INSTALLSITE}
cp __init__.py ${INSTALLSITE}
cp pymodule.py ${INSTALLSITE}
cp v2rdm_casscf.so ${INSTALLSITE}
mkdir -p ${INSTALLSITE}tests/v2rdm1
cp tests/v2rdm1/input.dat ${INSTALLSITE}tests/v2rdm1
mkdir -p ${INSTALLSITE}tests/v2rdm2
cp tests/v2rdm2/input.dat ${INSTALLSITE}tests/v2rdm2
mkdir -p ${INSTALLSITE}tests/v2rdm3
cp tests/v2rdm3/input.dat ${INSTALLSITE}tests/v2rdm3

