set +x

echo "" >> .messages.txt
echo "  Thank you for installing GDMA." >> .messages.txt
echo "    Manual:  http://www-stone.ch.cam.ac.uk/documentation/gdma/manual.pdf" >> .messages.txt
echo "    GitHub:  github.com/psi4/gdma" >> .messages.txt
echo "    Binary:  anaconda.org/psi4/gdma" >> .messages.txt
echo "    Inputs:  ${PREFIX}/share/psi4/samples/gdma" >> .messages.txt
echo "    Test (after first activating conda installation or environment):" >> .messages.txt
echo "      psi4 \"\$(dirname \$(which psi4))\"/../share/psi4/samples/gdma/gdma1/test.in" >> .messages.txt
echo "" >> .messages.txt

