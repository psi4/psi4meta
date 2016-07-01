set +x

echo "" >> .messages.txt
echo "  Thank you for installing PCMSolver." >> .messages.txt
echo "    Manual:  pcmsolver.readthedocs.io/en/latest/" >> .messages.txt
echo "    GitHub:  github.com/PCMSolver/pcmsolver" >> .messages.txt
echo "    Binary:  anaconda.org/psi4/pcmsolver" >> .messages.txt
echo "    Inputs:  ${PREFIX}/share/psi4/samples/pcmsolver" >> .messages.txt
echo "    Test (after first activating conda installation or environment):" >> .messages.txt
echo "      psi4 \"\$(dirname \$(which psi4))\"/../share/psi4/samples/pcmsolver/pcm-dft/test.in" >> .messages.txt
echo "" >> .messages.txt

