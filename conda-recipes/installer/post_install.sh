
if [ "$(uname)" == "Darwin" ]; then

    if hash install_name_tool 2>/dev/null; then
        echo "post-install: Fixing linking of lib/libpython2.7.dylib" >> .messages.txt
        install_name_tool -id @rpath/libpython2.7.dylib lib/libpython2.7.dylib

        #echo "post-install: Fixing linking of lib/libboost*.dylib" >> .messages.txt
        #for f in lib/libboost*.dylib; do
        #    if [ -f $f ] && ! [ -h $f ]; then
        #        #echo "post-install: Fixing linking of $f" >> .messages.txt
        #        install_name_tool -change /usr/lib/libstdc++.6.dylib @rpath/libstdc++.6.dylib $f
        #    fi
        #done
    else
        echo "For developers only: install_name_tool is not installed." >> .messages.txt
        echo "  If you build against this python library, you'll need to adjust the id of this" >> .messages.txt
        echo "    library or the rpath of your built executable." >> .messages.txt
        echo "  If you build against these boost libraries, you'll need to adjust the libstdc++" >> .messages.txt
        echo "    of these libraries or set DYLD_LIBRARY_PATH=${PREFIX}/lib" >> .messages.txt
        echo "    to run your built executable." >> .messages.txt
    fi

    echo "post-install: Removing interfering sqlite3 library" >> .messages.txt
    rm lib/libsqlite3.dylib
fi

if [ "$(uname)" == "Linux" ]; then

    echo '' >> .messages.txt

fi


# create input files

# ==> [0] Psi4 core <==
cat > linktest-psi4.in << EOL
memory 250 mb

molecule ethene_ethyne {
     0 1
     C     0.000000    -0.667578    -2.124659
     C     0.000000     0.667578    -2.124659
     H     0.923621    -1.232253    -2.126185
     H    -0.923621    -1.232253    -2.126185
     H    -0.923621     1.232253    -2.126185
     H     0.923621     1.232253    -2.126185
     --
     0 1
     C     0.000000     0.000000     2.900503
     C     0.000000     0.000000     1.693240
     H     0.000000     0.000000     0.627352
     H     0.000000     0.000000     3.963929
     units angstrom
}

set {
    basis         cc-pvdz
    guess         sad
    scf_type      df
    d_convergence 11
    puream        true
    print         1
}

energy('sapt0', molecule=ethene_ethyne)
compare_values(-0.00230683391, psi4.get_variable("SAPT0 TOTAL ENERGY"), 6, "Psi4")  #TEST
EOL

# ==> [1] Psi4 + DFTD3 executable <==
cat > linktest-dftd3.in << EOL
memory 250 mb

molecule eeee {
C  -0.471925  -0.471925  -1.859111
C   0.471925   0.471925  -1.859111
H  -0.872422  -0.872422  -0.936125
H   0.872422   0.872422  -0.936125
H  -0.870464  -0.870464  -2.783308
H   0.870464   0.870464  -2.783308
--
0 1
C  -0.471925   0.471925   1.859111
C   0.471925  -0.471925   1.859111
H  -0.872422   0.872422   0.936125
H   0.872422  -0.872422   0.936125
H  -0.870464   0.870464   2.783308
H   0.870464  -0.870464   2.783308
units angstrom
}

mBcp = eeee.extract_subsets(2, 1)
mBcp.update_geometry()

set basis sto-3g
set scf_type df
set dft_radial_points 50  # use really bad grid for speed since all we want is the -D value
set dft_spherical_points 110

energy('b3lyp-d3bj', molecule=mBcp)
compare_values(-77.62336232317983 + -0.00394342, get_variable('DFT TOTAL ENERGY'), 7, 'Psi4 + DFTD3 executable')  #TEST

set dft_radial_points 75
set dft_spherical_points 302
EOL

# ==> [2] Psi4 + CheMPS2 library <==
cat > linktest-chemps2.in << EOL
memory 250 mb

molecule N2 {
  N       0.0000   0.0000   0.0000
  N       0.0000   0.0000   2.1180
units au
}

set basis          cc-pVDZ
set reference      rhf
set e_convergence  1e-12
set d_convergence  1e-12

set dmrg_irrep              0
set dmrg_multiplicity       1
set restricted_docc         [ 1 , 0 , 0 , 0 , 0 , 1 , 0 , 0 ]
set active                  [ 2 , 0 , 1 , 1 , 0 , 2 , 1 , 1 ]

set dmrg_sweep_states       [   500,  1000,  1000 ]
set dmrg_sweep_energy_conv  [ 1e-10, 1e-10, 1e-10 ]
set dmrg_sweep_dvdson_rtol  [  1e-4,  1e-6,  1e-8 ]
set dmrg_sweep_max_sweeps   [     5,     5,    10 ]
set dmrg_sweep_noise_prefac [  0.05,  0.05,   0.0 ]
set dmrg_print_corr         true
set dmrg_mps_write          false

set dmrg_unitary_write      true
set dmrg_diis               true
set dmrg_scf_diis_thr       1e-2
set dmrg_diis_write         true

set dmrg_excitation         0   # Ground state
set dmrg_scf_state_avg      false
set dmrg_scf_active_space   NO  # INPUT; NO; LOC
set dmrg_local_init         false

energy("dmrg-scf")
compare_values(-109.1035023353, get_variable("CURRENT ENERGY"), 6, "Psi4 + CheMPS2 library")  #TEST
EOL

# ==> [3] Psi4 + PCMSolver library <==
cat > linktest-pcmsolver.in << EOL
memory 250 mb

molecule NH3 {
symmetry c1
N     -0.0000000001    -0.1040380466      0.0000000000
H     -0.9015844116     0.4818470201     -1.5615900098
H     -0.9015844116     0.4818470201      1.5615900098
H      1.8031688251     0.4818470204      0.0000000000
units bohr
no_reorient
no_com
}

set {
  basis STO-3G
  scf_type pk
  pcm true
  pcm_scf_type total
}

pcm = {
   Units = Angstrom
   Medium {
   SolverType = IEFPCM
   Solvent = Water
   }

   Cavity {
   RadiiSet = UFF
   Type = GePol
   Scaling = False
   Area = 0.3
   Mode = Implicit
   }
}

energy_scf1 = energy('scf')
compare_values(-55.4559426361734040, energy_scf1, 8, "Psi4 + PCMSolver library")
EOL

# ==> [4] Psi4 + V2RDM_CASSCF plugin <==
cat > linktest-v2rdm_casscf.in << EOL
memory 250 mb

molecule n2 {
0 1
n
n 1 r
}

set {
  basis cc-pvdz
  scf_type df
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
}

activate(n2)

n2.r     = 1.1
refscf   = -108.95348837831371 # TEST
refv2rdm = -109.094404909477   # TEST

energy('v2rdm-casscf')
compare_values(refv2rdm, get_variable("CURRENT ENERGY"), 5, "Psi4 + V2RDM_CASSCF plugin")  # TEST
EOL

# ==> [5] Psi4 + Ambit library <==
cat > linktest-ambit.in << EOL
memory 250 mb

import ambit

aA = ambit.Tensor(ambit.TensorType.CoreTensor, "A", [2, 2])
aB = ambit.Tensor(ambit.TensorType.CoreTensor, "B", [2, 2])
aC = ambit.Tensor(ambit.TensorType.CoreTensor, "C", [2, 2])

nA = np.asarray(aA)
nA.flat[:] = 3.0
nA = nA.copy()

nB = np.asarray(aB)
nB.flat[:] = 4.0
nB = nB.copy()

nC = np.asarray(aC)
nC.flat[:] = 0.0
nC = nC.copy()

# dot product
aC["ik"] = aA["ij"] * aB["jk"]
nC = np.dot(nA, nB)

compare_integers(1, int(np.allclose(aC, nC)), "Psi4 + Ambit library")  #TEST
EOL

# ==> [6] Psi4 library <==
cat > linktest-psi4so.py << EOL
import psi4

psi4.set_global_option('BASIS', 'AUG-CC-PVTZ')
bas = psi4.get_option('SCF', 'BASIS')

if bas == 'AUG-CC-PVTZ':
    print '\tPsi4 library......................................................PASSED'
else:
    print '\tPsi4 library......................................................FAILED'
EOL


# run test calculation
echo "  Testing:" >> .messages.txt
PSIOUT=`unset PSIDATADIR; PSI_SCRATCH=/tmp; PATH=$PREFIX/bin:$PATH; psi4 -i linktest-psi4.in -o linktest-psi4.out >> .messages.txt`
PSIOUT=`unset PSIDATADIR; PSI_SCRATCH=/tmp; PATH=$PREFIX/bin:$PATH; psi4 -i linktest-dftd3.in -o linktest-dftd3.out >> .messages.txt`
PSIOUT=`unset PSIDATADIR; PSI_SCRATCH=/tmp; PATH=$PREFIX/bin:$PATH; psi4 -i linktest-chemps2.in -o linktest-chemps2.out >> .messages.txt`
PSIOUT=`unset PSIDATADIR; PSI_SCRATCH=/tmp; PATH=$PREFIX/bin:$PATH; psi4 -i linktest-pcmsolver.in -o linktest-pcmsolver.out >> .messages.txt`
PSIOUT=`unset PSIDATADIR; PSI_SCRATCH=/tmp; PATH=$PREFIX/bin:$PATH; psi4 -i linktest-v2rdm_casscf.in -o linktest-v2rdm_casscf.out >> .messages.txt`
#PSIOUT=`unset PSIDATADIR; PSI_SCRATCH=/tmp; PATH=$PREFIX/bin:$PATH; psi4 -i linktest-ambit.in -o linktest-ambit.out >> .messages.txt`
PSIOUT=`unset PSIDATADIR; PSI_SCRATCH=/tmp; PATH=$PREFIX/bin:$PATH; python linktest-psi4so.py >> .messages.txt`
# remove temporary files
PSIOUT=`rm -f linktest* cavity.* timer.dat PEDRA.* *pcmsolver.inp >> .messages.txt`


# repeat configuration message since psi4 isn't last package installed
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
#echo "  Report installation problems at http://forum.psicode.org/t/report-conda-update-psi4-oddities-here/32" >> .messages.txt
#echo "" >> .messages.txt

