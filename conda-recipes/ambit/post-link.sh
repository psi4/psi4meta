set +x off

echo "" >> .messages.txt
echo "  Thank you for installing Ambit." >> .messages.txt
echo "    GitHub:  github.com/jturney/ambit" >> .messages.txt
echo "    Binary:  anaconda.org/psi4/ambit" >> .messages.txt
echo "    Inputs:  ${PREFIX}/lib/python2.7/site-packages/ambit/tests" >> .messages.txt
echo "    Test (after first activating conda installation or environment):" >> .messages.txt
echo "      python \"\$(dirname \$(which python ))\"/../lib/python2.7/site-packages/ambit/tests/test_operators.py" >> .messages.txt
echo "" >> .messages.txt

