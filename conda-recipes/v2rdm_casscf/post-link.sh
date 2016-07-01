set +x

echo "" >> .messages.txt
echo "  Thank you for installing the v2rdm_casscf plugin to Psi4." >> .messages.txt
echo "    GitHub:  github.com/edeprince3/v2rdm_casscf" >> .messages.txt
echo "    Binary:  anaconda.org/psi4/v2rdm_casscf" >> .messages.txt
echo "    Inputs:  ${PREFIX}/lib/python2.7/site-packages/v2rdm_casscf/tests" >> .messages.txt
echo "    Test (after first activating conda installation or environment):" >> .messages.txt
echo "      psi4 \"\$(dirname \$(which psi4))\"/../lib/python2.7/site-packages/v2rdm_casscf/tests/v2rdm1/input.dat -o output.dat" >> .messages.txt
echo "" >> .messages.txt

