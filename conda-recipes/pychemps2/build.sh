# configure
cd PyCheMPS2
export CPATH=${CPATH}:${PREFIX}/include

# build
${PYTHON} setup.py build_ext -L ${PREFIX}/lib

# install
${PYTHON} setup.py install --prefix=${PREFIX}

# test
export PYTHONPATH=${SRC_DIR}/build/lib.linux-x86_64-2.7/PyCheMPS2.so:$PYTHONPATH
cd tests
$PYTHON test1.py
$PYTHON test2.py
