# psi4DepsAppleClangCache.cmake
# -----------------------------
#
# This module sets some likely variable values to initialize the CMake
#   cache for dependencies to build your Psi4 source.
#   Note that this is for *Mac* and uses native (non-conda) tools, except
#   for gfortran, which is usable regardless of C/CXX compiler family.
#
# See ``psi4-path-advisor`` (or cmake command below) for use.
#
# >>> /opt/anaconda1anaconda2anaconda3/bin/cmake \
#       -H. \
#       -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsAppleClangCache.cmake \
#       -Bobjdir
#

set(CMAKE_C_COMPILER       "clang" CACHE STRING "")
set(CMAKE_CXX_COMPILER     "clang++" CACHE STRING "")
set(CMAKE_CXX_FLAGS        "-stdlib=libc++" CACHE STRING "")
set(CMAKE_Fortran_COMPILER "/opt/anaconda1anaconda2anaconda3/bin/gfortran" CACHE STRING "")

