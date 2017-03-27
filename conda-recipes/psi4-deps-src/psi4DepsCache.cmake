# psi4DepsCache.cmake
# -------------------
#
# This module sets some likely variable values to initialize the CMake
#   cache for dependencies to build your Psi4 source.
#
# See ``help-psi4-deps`` (or cmake command below) for use.
#
# >>> /opt/anaconda1anaconda2anaconda3/bin/cmake \
#       -H. \
#       -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsCache.cmake \
#       -Bobjdir

set(PYTHON_EXECUTABLE      "/opt/anaconda1anaconda2anaconda3/bin/python" CACHE STRING "")
set(PYTHON_LIBRARY         "/opt/anaconda1anaconda2anaconda3/lib/lib@PY_ABBR@.so" CACHE STRING "")
set(PYTHON_INCLUDE_DIR     "/opt/anaconda1anaconda2anaconda3/include/@PY_ABBR@" CACHE STRING "")

set(ENABLE_CheMPS2         ON CACHE BOOL "")
set(CheMPS2_DIR            "/opt/anaconda1anaconda2anaconda3/share/cmake/CheMPS2" CACHE PATH "")

set(ENABLE_libefp          ON CACHE BOOL "")
set(libefp_DIR             "/opt/anaconda1anaconda2anaconda3/share/cmake/libefp" CACHE PATH "")

set(ENABLE_erd             ON CACHE BOOL "")
set(erd_DIR                "/opt/anaconda1anaconda2anaconda3/share/cmake/erd" CACHE PATH "")

set(ENABLE_gdma            ON CACHE BOOL "")
set(gdma_DIR               "/opt/anaconda1anaconda2anaconda3/share/cmake/gdma" CACHE PATH "")

set(MAX_AM_ERI             "6" CACHE STRING "")
set(libint_DIR             "/opt/anaconda1anaconda2anaconda3/share/cmake/libint" CACHE PATH "")

set(ENABLE_PCMSolver       ON CACHE BOOL "")
set(PCMSolver_DIR          "/opt/anaconda1anaconda2anaconda3/share/cmake/PCMSolver" CACHE PATH "")

set(SPHINX_ROOT            "/opt/anaconda1anaconda2anaconda3" CACHE PATH "")
set(CMAKE_PROGRAM_PATH     "/opt/anaconda1anaconda2anaconda3" CACHE PATH "")
#set(CMAKE_INSTALL_PREFIX   "/opt/anaconda1anaconda2anaconda3" CACHE PATH "")


# for runtime, may want to activate for psiapi python, dftd3

# ZLIB_ROOT="${PFXC}" \
# CMAKE_PREFIX_PATH="${PREFIX}" \
# >>> ${PREFIX}/bin/cmake \



# Below are compiler and flags snippets for use or adaptation.
#   Remember the line continuance character "\" tolerates no
#   spaces afterwards or comments interspersed.

# Mac Clang
# ---------
#    -DCMAKE_C_COMPILER=clang \
#    -DCMAKE_CXX_COMPILER=clang++ \
#    -DCMAKE_CXX_FLAGS="-stdlib=libc++" \

# Mac GCC
# -------
    # Conda packages on the psi4 channel osx-64 arch are built with
    # clang/libc++, not gcc/libstdc++. They are therefore unsuited for
    # linking with a gcc-built Psi4, though the simplest ones (e.g.,
    # C-only libint) may work.

# Mac or Linux gfortran (independent of C/CXX compiler family)
# ---------------------
#    -DCMAKE_Fortran_COMPILER="/opt/anaconda1anaconda2anaconda3/bin/gfortran" \

# Linux GCC
# ---------
#    -DCMAKE_C_COMPILER="/opt/anaconda1anaconda2anaconda3/bin/gcc" \
#    -DCMAKE_CXX_COMPILER="/opt/anaconda1anaconda2anaconda3/bin/g++" \

# Linux Intel
# -----------
#    -DCMAKE_C_COMPILER=icc \
#    -DCMAKE_C_FLAGS="-gcc-name=/opt/anaconda1anaconda2anaconda3/bin/gcc" \
#    -DCMAKE_CXX_COMPILER=icpc \
#    -DCMAKE_CXX_FLAGS="-gcc-name=/opt/anaconda1anaconda2anaconda3/bin/gcc -gxx-name=/opt/anaconda1anaconda2anaconda3/bin/g++" \
#    -DCMAKE_Fortran_COMPILER=ifort \
#    -DCMAKE_Fortran_FLAGS="-gcc-name=/opt/anaconda1anaconda2anaconda3/bin/gcc -gxx-name=/opt/anaconda1anaconda2anaconda3/bin/g++" \
