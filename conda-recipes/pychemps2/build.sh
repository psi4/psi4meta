cd PyCheMPS2
export CPATH=${CPATH}:${PREFIX}/include
${PYTHON} setup.py build_ext -L ${PREFIX}/lib
${PYTHON} setup.py install --prefix=${PREFIX}

