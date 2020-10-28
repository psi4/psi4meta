# psi4DepsClangCache.cmake
# ------------------------
#
# This module sets some likely variable values to initialize the CMake
#   cache for dependencies to build your Psi4 source.
# Note that this is for *Mac* and uses conda tools. Do not try to mix
#   with packages built with gcc/libstdc++, though the
#   simplest ones (e.g., C-only Libint) may work.
#
# See ``psi4-path-advisor`` (or cmake command below) for use.
#
# >>> /opt/anaconda1anaconda2anaconda3/bin/cmake \
#       -H. \
#       -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsClangCache.cmake \
#       -Bobjdir
#

set(CMAKE_C_COMPILER       "/opt/anaconda1anaconda2anaconda3/bin/@HOST@-clang" CACHE STRING "")
set(CMAKE_CXX_COMPILER     "/opt/anaconda1anaconda2anaconda3/bin/@HOST@-clang++" CACHE STRING "")
#set(CMAKE_CXX_FLAGS        "-stdlib=libc++" CACHE STRING "")
set(CMAKE_Fortran_COMPILER "/opt/anaconda1anaconda2anaconda3/bin/@HOST@-gfortran" CACHE STRING "")

# aka
#set(CMAKE_C_COMPILER       "${CLANG}" CACHE STRING "")
#set(CMAKE_CXX_COMPILER     "${CLANGXX}" CACHE STRING "")
#set(CMAKE_Fortran_COMPILER "${GFORTRAN}" CACHE STRING "")
