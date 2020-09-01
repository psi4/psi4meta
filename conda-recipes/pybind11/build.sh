# Install headers with projectConfig.cmake files with cmake
mkdir build
cd build

cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DUSE_PYTHON_INCLUDE_DIR=OFF \
  -DPYTHON_EXECUTABLE=$PREFIX/bin/python \
  -DPYBIND11_TEST=OFF \
  $SRC_DIR

make
make install
cd ..

# Install Python package
#export PYBIND11_USE_CMAKE=1
#cd $SRC_DIR
#python $SRC_DIR/setup.py install --single-version-externally-managed --record record.txt

