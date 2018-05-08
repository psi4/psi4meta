# configure
cd PyCheMPS2
if [ "$(uname)" == "Darwin" ]; then
    export CC=clang
    export CXX=clang++
    export CFLAGS="-stdlib=libc++"
fi
export CPATH=${CPATH}:${PREFIX}/include

# build
${PYTHON} setup.py build_ext -L ${PREFIX}/lib

# install
${PYTHON} setup.py install --prefix=${PREFIX}

# test
cd tests
$PYTHON test1.py
$PYTHON test2.py
