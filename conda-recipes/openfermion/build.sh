${PYTHON} setup.py install --single-version-externally-managed --record=record.txt

# single-version-externally-managed puts data_files into root, not module, so shift them
#mv ${PREFIX}/openfermion/examples/ ${SP_DIR}/openfermion/
