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

set(Python_EXECUTABLE      "/opt/anaconda1anaconda2anaconda3/bin/python" CACHE STRING "")
# below can return w/o "m" when min is py38 and lib/includes names are uniform again
#set(Python_LIBRARY         "/opt/anaconda1anaconda2anaconda3/lib/libpython@PY_VER@m.so" CACHE STRING "")
#set(Python_INCLUDE_DIR     "/opt/anaconda1anaconda2anaconda3/include/python@PY_VER@m" CACHE STRING "")

set(pybind11_DIR            "/opt/anaconda1anaconda2anaconda3/share/cmake/pybind11" CACHE PATH "")

set(ENABLE_ambit           ON CACHE BOOL "")
set(ambit_DIR              "/opt/anaconda1anaconda2anaconda3/share/cmake/ambit" CACHE PATH "")

set(ENABLE_CheMPS2         ON CACHE BOOL "")
set(CheMPS2_DIR            "/opt/anaconda1anaconda2anaconda3/share/cmake/CheMPS2" CACHE PATH "")

set(ENABLE_dkh             ON CACHE BOOL "")
set(dkh_DIR                "/opt/anaconda1anaconda2anaconda3/share/cmake/dkh" CACHE PATH "")

#set(ENABLE_libefp          ON CACHE BOOL "")
#set(libefp_DIR             "/opt/anaconda1anaconda2anaconda3/share/cmake/libefp" CACHE PATH "")

#set(ENABLE_erd             ON CACHE BOOL "")
#set(erd_DIR                "/opt/anaconda1anaconda2anaconda3/share/cmake/erd" CACHE PATH "")

set(gau2grid_DIR           "/opt/anaconda1anaconda2anaconda3/share/cmake/gau2grid" CACHE PATH "")

set(ENABLE_gdma            ON CACHE BOOL "")
set(gdma_DIR               "/opt/anaconda1anaconda2anaconda3/share/cmake/gdma" CACHE PATH "")

set(MAX_AM_ERI             "5" CACHE STRING "")
set(Libint2_DIR            "/opt/anaconda1anaconda2anaconda3/share/cmake/Libint2" CACHE PATH "")

set(ENABLE_PCMSolver       OFF CACHE BOOL "")
set(PCMSolver_DIR          "/opt/anaconda1anaconda2anaconda3/share/cmake/PCMSolver" CACHE PATH "")

set(ENABLE_simint          ON CACHE BOOL "")
set(simint_DIR             "/opt/anaconda1anaconda2anaconda3/share/cmake/simint" CACHE PATH "")

set(Libxc_DIR              "/opt/anaconda1anaconda2anaconda3/share/cmake/Libxc" CACHE PATH "")

set(SPHINX_ROOT            "/opt/anaconda1anaconda2anaconda3" CACHE PATH "")
set(CMAKE_PROGRAM_PATH     "/opt/anaconda1anaconda2anaconda3" CACHE PATH "")
set(Eigen3_DIR             "/opt/anaconda1anaconda2anaconda3/share/eigen3/cmake/" CACHE PATH "")
set(MPFR_ROOT              "/opt/anaconda1anaconda2anaconda3" CACHE PATH "")

