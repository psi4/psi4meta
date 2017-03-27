if [[ "${CONDA_PY}" == "27" ]]; then
    PY_ABBR="python2.7"
elif [[ "${CONDA_PY}" == "35" ]]; then
    PY_ABBR="python3.5m"
elif [[ "${CONDA_PY}" == "36" ]]; then
    PY_ABBR="python3.6m"
fi

# install
mkdir -p ${PREFIX}/share/cmake/psi4/
sed "s/@PY_ABBR@/${PY_ABBR}/g" psi4DepsCache.cmake > ${PREFIX}/share/cmake/psi4/psi4DepsCache.cmake
cp help_psi4_deps.py ${SP_DIR}
