cmake_minimum_required(VERSION 3.3 FATAL_ERROR)

project(gcp
        VERSION 2.0.2
        LANGUAGES Fortran)
set(dftd3_AUTHORS      "Stefan Grimme")
#set(dftd3_DESCRIPTION  "dispersion correction for DFT, Hartree–Fock, and semi-empirical quantum chemical methods")
#set(dftd3_URL          "https://www.chemie.uni-bonn.de/pctc/mulliken-center/software/dft-d3")
set(dftd3_LICENSE      "GPLv1+")

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

################  Options: Overview and Not Otherwise Mentioned  ###############

#  <<<  CMake build overview  >>>
#
#    >>> ls
#    dftd3.f LICENSE pars.f ...
#    >>> cmake -H. -Bobjdir -DCMAKE_INSTALL_PREFIX=/path/to/install-dftd3 ...
#    ...
#    -- Generating done
#    -- Build files have been written to: /current/dir/objdir
#    >>> cd objdir && make -j`getconf _NPROCESSORS_ONLN`
#    >>> make install

#  <<<  Required build dependencies that DFTD3 can't build itself  >>>
#
#    - CMake (e.g., `conda install cmake`)
#    - Fortran compiler

############################  Options: Build How?  #############################

set(CMAKE_BUILD_TYPE Release)

#################################  Main Project  ################################
include(GNUInstallDirs)
include(autocmake_safeguards)

# <<<  Build >>>

set(sources_list stringmod.f90 gcp.f90)

add_executable(gcp ${sources_list})

# <<<  Install  >>>

install(TARGETS gcp
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
