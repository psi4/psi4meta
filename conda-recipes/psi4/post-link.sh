set +x

echo "" >> .messages.txt
echo "  Thank you for installing psi4." >> .messages.txt
echo "    Website: psicode.org" >> .messages.txt
echo "    Forum:   forum.psi4code.org" >> .messages.txt
echo "    Manual:  psicode.org/psi4manual/master/index.html" >> .messages.txt
echo "    GitHub:  github.com/psi4/psi4" >> .messages.txt
echo "    Binary:  anaconda.org/psi4/psi4" >> .messages.txt
echo "    Inputs:  ${PREFIX}/share/psi4/samples" >> .messages.txt
#echo "    Runtime Environment Diagnostic: ${PREFIX}/share/psi4/scripts/setenv.py"
echo "    Youtube: youtube.com/user/psitutorials" >> .messages.txt
echo "    Test (after first activating conda installation or environment):" >> .messages.txt
echo "      psi4 \"\$(dirname \$(which psi4))\"/../share/psi4/samples/sapt1/test.in" >> .messages.txt
echo "" >> .messages.txt
echo "  For csh/tcsh command-line use, add to shell or ~/.tcshrc file:" >> .messages.txt
echo "    unsetenv PSIDATADIR" >> .messages.txt
echo "    setenv PATH ${PREFIX}/bin:\$PATH" >> .messages.txt
echo "    setenv PSI_SCRATCH /path/to/existing/writable/local-not-network/disk/for/scratch/files" >> .messages.txt
echo "" >> .messages.txt
if [ "$(uname)" == "Darwin" ]; then
echo "  For sh/bash command-line use, add to shell or ~/.bash_profile file:" >> .messages.txt
elif [ "$(uname)" == "Linux" ]; then
echo "  For sh/bash command-line use, add to shell or ~/.bashrc file:" >> .messages.txt
fi
echo "    unset PSIDATADIR" >> .messages.txt
echo "    export PATH=${PREFIX}/bin:\$PATH" >> .messages.txt
echo "    export PSI_SCRATCH=/path/to/existing/writable/local-not-network/disk/for/scratch/files" >> .messages.txt
echo "" >> .messages.txt
#echo "  Report problems at http://forum.psicode.org/t/report-conda-update-psi4-oddities-here/32" >> .messages.txt
#echo "" >> .messages.txt

