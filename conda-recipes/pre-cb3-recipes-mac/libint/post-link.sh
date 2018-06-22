set +x

echo "" >> .messages.txt
echo "  Thank you for installing Libint." >> .messages.txt
echo "    Manual:  github.com/psi4/libint/blob/master/README.md" >> .messages.txt
echo "    GitHub:  github.com/evaleev/libint/tree/v1" >> .messages.txt
echo "    Binary:  anaconda.org/psi4/libint" >> .messages.txt
#echo "    Inputs:  ${PREFIX}/share/psi4/samples/dmrg" >> .messages.txt
echo "    Test (after first activating conda installation or environment):" >> .messages.txt
echo "      psi4 \"\$(dirname \$(which psi4))\"/../share/psi4/samples/mints3/test.in" >> .messages.txt
echo "" >> .messages.txt

