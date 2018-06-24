# psi4DepsMKLCache.cmake
# ----------------------
#
# This module sets some likely variable values to initialize the CMake
#   cache for dependencies to build your Psi4 source.
#
# See ``psi4-path-advisor`` (or cmake command below) for use.
#
# >>> /opt/anaconda1anaconda2anaconda3/bin/cmake \
#       -H. \
#       -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsMKLCache.cmake \
#       -Bobjdir
#

set(LAPACK_LIBRARIES       "/opt/anaconda1anaconda2anaconda3/lib/libmkl_rt@SHLIB_EXT@;/opt/anaconda1anaconda2anaconda3/lib/libiomp5@SHLIB_EXT@;-Wl,--as-needed" CACHE STRING "")
set(LAPACK_INCLUDE_DIRS    "/opt/anaconda1anaconda2anaconda3/include" CACHE STRING "")

