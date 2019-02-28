set "CVXOPT_BLAS_LIB_DIR=%LIBRARY_LIB%"

if "%blas_impl%" == "mkl" (
    set "CVXOPT_BLAS_LIB=mkl_rt"
    set "CVXOPT_LAPACK_LIB=mkl_rt"
    )
if "%blas_impl%" == "openblas" (
    set "CVXOPT_BLAS_LIB=openblas"
    set "CVXOPT_LAPACK_LIB=openblas"
    )

set CVXOPT_BUILD_GSL=1
set "CVXOPT_GSL_LIB_DIR=%LIBRARY_LIB%"
set "CVXOPT_GSL_INC_DIR=%LIBRARY_INC%"

set CVXOPT_BUILD_FFTW=1
set "CVXOPT_FFTW_LIB_DIR=%LIBRARY_LIB%"
set "CVXOPT_FFTW_INC_DIR=%LIBRARY_INC%"

set CVXOPT_BUILD_GLPK=1
set "CVXOPT_GLPK_LIB_DIR=%LIBRARY_LIB%"
set "CVXOPT_GLPK_INC_DIR=%LIBRARY_INC%"

IF "%vc%" LSS "14" (
   set C99_TO_C89_WRAP_DEBUG_LEVEL=1
   set C99_TO_C89_WRAP_SAVE_TEMPS=1
   set C99_TO_C89_WRAP_NO_LINE_DIRECTIVES=1
   set C99_TO_C89_CONV_DEBUG_LEVEL=1
   COPY "%LIBRARY_BIN%\c99wrap.exe" "%LIBRARY_BIN%\cl.exe"
   set CC=c99wrap
   )

set "CVXOPT_MSVC=1"

%PYTHON% setup.py install --single-version-externally-managed --record=record.txt
