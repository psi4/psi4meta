set +x off

# print install text
echo ""
echo ""
echo "  Thank you for installing the v2rdm_casscf plugin to psi4. Additional resources:"
echo "    Inputs:  ${PREFIX}/lib/python2.7/site-packages/v2rdm_casscf/tests"
echo "    GitHub:  https://github.com/edeprince3/v2rdm_casscf"
echo "    Binary:  https://anaconda.org/v2rdm_casscf"
echo ""
echo "  Test with below, after first activating conda environment if installed into environment:"
echo "    psi4 \"\$(dirname \$(which psi4))\"/../lib/python2.7/site-packages/v2rdm_casscf/tests/v2rdm1/input.dat -o output.dat"
echo ""

