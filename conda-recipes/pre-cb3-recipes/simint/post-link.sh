set +x

echo "" >> .messages.txt
echo "  Thank you for installing SIMINT." >> .messages.txt
echo "    Manual:  http://www.bennyp.org/research/simint/" >> .messages.txt
echo "    GitHub:  github.com/simint-chem/simint-generator" >> .messages.txt
echo "    Binary:  anaconda.org/psi4/simint" >> .messages.txt
echo "    Inputs:  ${PREFIX}/share/psi4/samples/simint" >> .messages.txt
echo "    Test (after first activating conda installation or environment):" >> .messages.txt
echo "      psi4 \"\$(dirname \$(which psi4))\"/../share/psi4/samples/simint/scf5/test.in" >> .messages.txt
echo "" >> .messages.txt

