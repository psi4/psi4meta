set +x

echo "" >> .messages.txt
echo "  Thank you for installing ERD." >> .messages.txt
#echo "    Manual:  http://www.libefp.org/" >> .messages.txt
echo "    GitHub:  github.com/psi4/erd" >> .messages.txt
echo "    Binary:  anaconda.org/psi4/erd" >> .messages.txt
echo "    Inputs:  ${PREFIX}/share/psi4/samples/erd" >> .messages.txt
echo "    Test (after first activating conda installation or environment):" >> .messages.txt
echo "      psi4 \"\$(dirname \$(which psi4))\"/../share/psi4/samples/erd/scf5/test.in" >> .messages.txt
echo "" >> .messages.txt

