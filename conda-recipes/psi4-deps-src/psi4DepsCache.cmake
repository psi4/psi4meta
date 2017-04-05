# psi4DepsCache.cmake
# -------------------
#
# This module sets some likely variable values to initialize the CMake
#   cache for dependencies to build your Psi4 source.
#
# See ``psi4-path-advisor`` (or cmake command below) for use.
#
# >>> /opt/anaconda1anaconda2anaconda3/bin/cmake \
#       -H. \
#       -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsCache.cmake \
#       -Bobjdir
#

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

set(ENABLE_simint          ON CACHE BOOL "")
set(simint_DIR             "/opt/anaconda1anaconda2anaconda3/share/cmake/simint" CACHE PATH "")

set(SPHINX_ROOT            "/opt/anaconda1anaconda2anaconda3" CACHE PATH "")
set(CMAKE_PROGRAM_PATH     "/opt/anaconda1anaconda2anaconda3" CACHE PATH "")

