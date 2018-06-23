# psi4DepsGNUCache.cmake
# ----------------------
#
# This module sets some likely variable values to initialize the CMake
#   cache for dependencies to build your Psi4 source.
# Note for Mac: Due to packages from the psi4 conda channel osx-64 arch
#   being built with clang/libc++ (rather than gcc/libstdc++), these lines
#   are **not appropriate** for linking with a gcc-build Psi4, though the
#   simplest ones (e.g., C-only Libint) may work.
#
# See ``psi4-path-advisor`` (or cmake command below) for use.
#
# >>> /opt/anaconda1anaconda2anaconda3/bin/cmake \
#       -H. \
#       -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsGNUCache.cmake \
#       -Bobjdir
#

set(CMAKE_C_COMPILER       "/opt/anaconda1anaconda2anaconda3/bin/@HOST@-gcc" CACHE STRING "")
set(CMAKE_CXX_COMPILER     "/opt/anaconda1anaconda2anaconda3/bin/@HOST@-g++" CACHE STRING "")
set(CMAKE_Fortran_COMPILER "/opt/anaconda1anaconda2anaconda3/bin/@HOST@-gfortran" CACHE STRING "")

# aka
#set(CMAKE_C_COMPILER       "\${GCC}" CACHE STRING "")
#set(CMAKE_CXX_COMPILER     "\${GXX}" CACHE STRING "")
#set(CMAKE_Fortran_COMPILER "\${GFORTRAN}" CACHE STRING "")
