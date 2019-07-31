# install
SHARE=${PREFIX}/share/cmake/psi4/
mkdir -p ${SHARE}

if [ "$(uname)" == "Darwin" ]; then
    cp psi4PluginCacheosx.cmake t_plug0
    sed "s/@HOST@/${HOST}/g" psi4DepsClangCache.cmake > ${SHARE}/psi4DepsClangCache.cmake
elif [ "$(uname)" == "Linux" ]; then
    cp psi4PluginCachelinux.cmake t_plug0
    sed "s/@HOST@/${HOST}/g" psi4DepsGNUCache.cmake > ${SHARE}/psi4DepsGNUCache.cmake
    sed "s/@HOST@/${HOST}/g" psi4DepsIntelCache.cmake > ${SHARE}/psi4DepsIntelCache.cmake
    sed "s/@HOST@/${HOST}/g" psi4DepsIntelMultiarchCache.cmake > ${SHARE}/psi4DepsIntelMultiarchCache.cmake
fi
sed "s;@PYMOD_INSTALL_LIBDIR@;${PYMOD_INSTALL_LIBDIR};g" t_plug0 > t_plug1
sed "s/@HOST@/${HOST}/g" t_plug1 > t_plug2

cp psi4-path-advisor.py ${PREFIX}/bin/psi4-path-advisor
cp t_plug2 ${SHARE}/psi4PluginCache.cmake
sed "s/@PY_ABBR@/${PY_ABBR}/g" psi4DepsCache.cmake > ${SHARE}/psi4DepsCache.cmake
cp psi4DepsDisableCache.cmake ${SHARE}
sed "s/@SHLIB_EXT@/${SHLIB_EXT}/g" psi4DepsMKLCache.cmake > ${SHARE}/psi4DepsMKLCache.cmake
