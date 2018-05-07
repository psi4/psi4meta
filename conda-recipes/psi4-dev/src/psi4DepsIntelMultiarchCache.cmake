# psi4DepsIntelMultiarchCache.cmake
# ---------------------------------
#
# This module sets some likely variable values to initialize the CMake
#   cache for dependencies to build your Psi4 source.
#   Note that this uses user-provided (non-conda) Intel compiler tools
#   expected to be in :envvar:PATH .
#   Additionally, it sets up the compilation to optimize for multiple
#   instruction sets, not just native or least-common-denominator
#
# See ``psi4-path-advisor`` (or cmake command below) for use.
#
# >>> /opt/anaconda1anaconda2anaconda3/bin/cmake \
#       -H. \
#       -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsIntelMultiarchCache.cmake \
#       -Bobjdir
#

set(CMAKE_C_COMPILER       "icc" CACHE STRING "")
set(CMAKE_CXX_COMPILER     "icpc" CACHE STRING "")
set(CMAKE_Fortran_COMPILER "ifort" CACHE STRING "")

set(ENABLE_XHOST           OFF CACHE BOOL "")
set(CMAKE_C_FLAGS          "-gnu-prefix=/opt/anaconda1anaconda2anaconda3/bin/@HOST@- --sysroot=/opt/anaconda1anaconda2anaconda3/@HOST@/sysroot -msse2 -axCORE-AVX2,AVX" CACHE STRING "")
set(CMAKE_CXX_FLAGS        "-gnu-prefix=/opt/anaconda1anaconda2anaconda3/bin/@HOST@- --sysroot=/opt/anaconda1anaconda2anaconda3/@HOST@/sysroot -msse2 -axCORE-AVX2,AVX" CACHE STRING "")
set(CMAKE_Fortran_FLAGS    "-gnu-prefix=/opt/anaconda1anaconda2anaconda3/bin/@HOST@- --sysroot=/opt/anaconda1anaconda2anaconda3/@HOST@/sysroot -msse2 -axCORE-AVX2,AVX" CACHE STRING "")

