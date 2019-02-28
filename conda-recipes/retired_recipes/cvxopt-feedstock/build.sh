#!/bin/bash


export CVXOPT_BLAS_LIB_DIR="${PREFIX}/lib"

if [ "$blas_impl" == "mkl" ]; then
    export CVXOPT_BLAS_LIB="mkl_rt"
    export CVXOPT_LAPACK_LIB="mkl_rt"
elif [ "$blas_impl" == "openblas" ]; then
    export CVXOPT_BLAS_LIB="openblas"
    export CVXOPT_LAPACK_LIB="openblas"
else
    echo "blas_impl undefined in variant or not recognized.  Edit cvxopt's build.sh if you need to add a new supported blas"
fi

export CVXOPT_BUILD_GSL=1
export CVXOPT_GSL_LIB_DIR="${PREFIX}/lib"
export CVXOPT_GSL_INC_DIR="${PREFIX}/include"

export CVXOPT_BUILD_FFTW=1
export CVXOPT_FFTW_LIB_DIR="${PREFIX}/lib"
export CVXOPT_FFTW_INC_DIR="${PREFIX}/include"

export CVXOPT_BUILD_GLPK=1
export CVXOPT_GLPK_LIB_DIR="${PREFIX}/lib"
export CVXOPT_GLPK_INC_DIR="${PREFIX}/include"

export CVXOPT_SUITESPARSE_LIB_DIR="${PREFIX}/lib"
export CVXOPT_SUITESPARSE_INC_DIR="${PREFIX}/include"

$PYTHON setup.py install --single-version-externally-managed --record=record.txt
