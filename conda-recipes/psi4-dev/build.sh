# install
SHARE=${PREFIX}/share/cmake/psi4/
mkdir -p ${SHARE}
cp psi4-path-advisor.py ${PREFIX}/bin/psi4-path-advisor
sed "s/@PY_ABBR@/${PY_ABBR}/g" psi4DepsCache.cmake > ${SHARE}/psi4DepsCache.cmake
sed "s/@HOST@/${HOST}/g" psi4DepsIntelMultiarchCache.cmake > ${SHARE}/psi4DepsIntelMultiarchCache.cmake
cp psi4DepsAppleClangCache.cmake ${SHARE}
cp psi4DepsDisableCache.cmake ${SHARE}
sed "s/@HOST@/${HOST}/g" psi4DepsIntelCache.cmake > ${SHARE}/psi4DepsIntelCache.cmake
sed "s/@HOST@/${HOST}/g" psi4DepsGNUCache.cmake > ${SHARE}/psi4DepsGNUCache.cmake
sed "s/@SHLIB_EXT@/${SHLIB_EXT}/g" psi4DepsMKLCache.cmake > ${SHARE}/psi4DepsMKLCache.cmake

