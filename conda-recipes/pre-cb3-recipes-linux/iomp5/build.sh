# load Intel compilers and mkl
source /theoryfs2/common/software/intel2015/bin/compilervars.sh intel64
# force static link to Intel mkl, except for openmp
#MKLROOT=/theoryfs2/common/software/intel2015/composer_xe_2015.0.090/mkl/lib/intel64
MKLROOT=/theoryfs2/common/software/intel2015/composer_xe_2015.3.187/mkl/lib/intel64
# redistribute the Intel openmp
REDIST=${MKLROOT}/../../../compiler/lib/intel64/libiomp5.so

mkdir ${PREFIX}/lib
cp ${REDIST} ${PREFIX}/lib

