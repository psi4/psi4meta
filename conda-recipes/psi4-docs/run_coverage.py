import os
import copy
import time
from pathlib import Path
import subprocess as sp
from multiprocessing import Pool

objdir = Path(os.environ['SRC_DIR']) / 'build'
cb_threads = int(os.environ['CPU_COUNT'])
coverage_exe = Path(os.environ['PREFIX']) / 'bin' / 'coverage'
lenv = copy.deepcopy(os.environ)
pythonpath = objdir / 'stage' / 'lib' / ('python' + os.environ['PY_VER']) / 'site-packages'
lenv['PYTHONPATH'] = str(pythonpath)

os.chdir(objdir)
test_time = time.time()
outfile = open("output_coverage", "w")
errfile = open("error_coverage", "w")

print('objdir/CWD:', os.getcwd())

exclude_addons_missing = [
    'cfour',
    'chemps2',
    'dkh',
    'gdma',
    'gpu_dfcc',
    'mrcc',
    'optking',  # RAK scratch
    'pasture',
    'pcmsolver',
    'snsmp2',
    'v2rdm_casscf',
]

exclude_need_ctest_file_manipulation = [
    'cookbook-manual-sow-reap',
    'ci-property',
    'cubeprop',
    'cubeprop-esp',
    'cubeprop-frontier',
    'dftd3-psithon2',
    'fcidump',
    'fsapt-terms',
    'mp2-property',
    'psiaux1-myplugin1',
    'psithon2',
    'pywrap-db2',
    'pywrap-freq-e-sowreap',
    'pywrap-freq-g-sowreap',
    'scf-property',
    # not actually test cases
    'dft-dsd',
    'fsapt-diff1',
    'large-atoms',
]

exclude_too_long = [
    'cbs-xtpl-func',  # 200
    'cc13a',  # 100
    'dcft7',  # 100
    'dft-bench-interaction',  # 2500
    'dft-bench-ionization',  # 1300
    'fd-freq-energy-large',  # 200
    'fd-freq-gradient-large',  # 200
    'frac-traverse',  # 100
    'fsapt-allterms',  # 200
    'fsapt1',  # 400
    'isapt1',  # 300
    'opt13',  # 200
    'python-vibanalysis',  # 700
    'sapt2',  # 100
    'sapt4',  # 100
    'scf-bz2',  # 100
    'cc5',  # D4800
    'opt10',  # D4000
    'opt-multi-frozen-dimer-c2h',  # D300
    'opt-multi-dimer-c2h',  # D300
    'opt-multi-dimer-c1',  # D300
    'mp2-def2',  # D300
    'psimrcc-fd-freq2',  # D300
    'optking-dlpc',  # many hours
]


def do_skip(tlabel):
    if tlabel in exclude_too_long:
        return True

    if tlabel in exclude_need_ctest_file_manipulation:
        return True

    for chunk in exclude_addons_missing:
        if tlabel.startswith(chunk):
            return True

    return False


files = []
for ext in ['.dat', '.py']:
    files.extend(Path('.').glob('../tests/**/input' + ext))

#files = Path('.').glob('../tests/scf*/input.dat')
#files = Path('.').glob('../tests/[jl]*/*/input.[pd]*')


idx = 1
filteredtests = []
for tpath in files:
    tlabel = tpath.parent.stem
    dir_up = tpath.parent.parent.stem
    if dir_up != 'tests':
        # e.g., dftd3-energy
        tlabel = '-'.join([dir_up, tlabel])

    if do_skip(tlabel):
        print("        Skip  {:4}  {}".format('', tlabel))
    else:
        print("        Run   {:4}  {}".format('#' + str(idx), tlabel))
        filteredtests.append((idx, tpath, tlabel))
        idx += 1

total_files = len(filteredtests)
print("\n\n ==> Running {} test cases -j{} <== \n".format(total_files, cb_threads))


def run_test(fname):
    tnum, tpath, tlabel = fname

    if tpath.name == "input.dat":
        cmd = [coverage_exe, "run", "--parallel-mode", "stage/bin/psi4", tpath]
    elif tpath.name == "input.py":
        cmd = [coverage_exe, "run", "--parallel-mode", tpath]

    t = time.time()
    outfile.write('<<<  #{} {}  >>>'.format(tnum, tlabel))
    retcode = sp.call(cmd, stdout=outfile, stderr=errfile, env=lenv)
    total_time = time.time() - t

    if retcode == 0:
        print("%3d/%3d  Success! %40s (%8.2f seconds)" % (tnum, total_files, tlabel, total_time))
    else:
        print("%3d/%3d  Failure! %40s (%8.2f seconds) ***" % (tnum, total_files, tlabel, total_time))


p = Pool(cb_threads, maxtasksperchild=1)
p.map(run_test, filteredtests, chunksize=1)

print("\n\n ==> Combining Python data <== \n")

sp.call([coverage_exe, "combine"])
sp.call([coverage_exe, "report"])

outfile.close()
errfile.close()

test_time = time.time() - test_time
print("Total testing time %.2f seconds." % test_time)
