if [[ "${CONDA_PY}" == "27" ]]; then
    PY_ABBR="python2.7"
elif [[ "${CONDA_PY}" == "35" ]]; then
    PY_ABBR="python3.5m"
elif [[ "${CONDA_PY}" == "36" ]]; then
    PY_ABBR="python3.6m"
fi

# install
SHARE=${PREFIX}/share/cmake/psi4/
mkdir -p ${SHARE}
cp psi4-path-advisor.py ${PREFIX}/bin/psi4-path-advisor
sed "s/@PY_ABBR@/${PY_ABBR}/g" psi4DepsCache.cmake > ${SHARE}/psi4DepsCache.cmake
cp psi4DepsAppleClangCache.cmake ${SHARE}
cp psi4DepsDisableCache.cmake ${SHARE}
cp psi4DepsIntelCache.cmake ${SHARE}
cp psi4DepsGNUCache.cmake ${SHARE}

