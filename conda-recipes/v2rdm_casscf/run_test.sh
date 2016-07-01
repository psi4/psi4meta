set +x

# create input file
cat > linktest.in << EOL
#! cc-pvdz N2 (6,6) active space Test DQG

# job description:
print '        N2 / cc-pVDZ / DQG(6,6), scf_type = CD / 1e-12, rNN = 0.5 A'

molecule n2 {
0 1
n
n 1 r
}

molecule interloper {
0 1
O
H 1 1.0
H 1 1.0 2 90.0
}

set {
  basis cc-pvdz
  scf_type cd
  cholesky_tolerance 1e-12
  d_convergence      1e-10
  maxiter 500
  restricted_docc [ 2, 0, 0, 0, 0, 2, 0, 0 ]
  active          [ 1, 0, 1, 1, 0, 1, 1, 1 ]
}
set v2rdm_casscf {
  positivity dqg
  r_convergence  1e-5
  e_convergence  1e-6
  maxiter 20000
  #orbopt_frequency    1000
  #mu_update_frequency 1000
}

n2.r     = 0.5
refscf   = -103.04337420425350 # TEST
refv2rdm = -103.086205379481   # TEST

energy('v2rdm-casscf', molecule=n2)

compare_values(refscf, get_variable("SCF TOTAL ENERGY"), 8, "SCF total energy") # TEST
compare_values(refv2rdm, get_variable("CURRENT ENERGY"), 5, "v2RDM-CASSCF total energy") # TEST
EOL

# run test calculation
PSIOUT=`PSI_SCRATCH=/tmp; psi4 -i linktest.in -o linktest.out > linktest.txt`
echo $PSIOUT >> .messages.txt
# print test results
cat linktest.txt >> .messages.txt
echo "" >> .messages.txt
# remove temporary files
rm -f linktest.in linktest.out linktest.txt timer.dat

