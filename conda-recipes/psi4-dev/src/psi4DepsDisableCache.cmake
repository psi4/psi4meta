# psi4DepsDisableCache.cmake
# --------------------------
#
# This module cancels the enabling of the link-time Add-Ons set by
#   psi4DepsCache.cmake. Use *after* that file.
#
# See ``psi4-path-advisor`` (or cmake command below) for use.
#
# >>> /opt/anaconda1anaconda2anaconda3/bin/cmake \
#       -S. \
#       -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsCache.cmake \
#       -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsDisableCache.cmake \
#       -Bobjdir
#

set(ENABLE_ambit           OFF CACHE BOOL "" FORCE)
set(ENABLE_CheMPS2         OFF CACHE BOOL "" FORCE)
set(ENABLE_dkh             OFF CACHE BOOL "" FORCE)
set(ENABLE_ecpint          OFF CACHE BOOL "" FORCE)
set(ENABLE_erd             OFF CACHE BOOL "" FORCE)
set(ENABLE_gdma            OFF CACHE BOOL "" FORCE)
set(ENABLE_PCMSolver       OFF CACHE BOOL "" FORCE)
set(ENABLE_simint          OFF CACHE BOOL "" FORCE)

