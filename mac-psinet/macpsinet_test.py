#!/usr/bin/env python
import re
import os
import sys
import time
import subprocess

distelli_num = os.getenv('DISTELLI_BUILDNUM', 'local_build')
#logfile = "/Users/github/psi_logs/" + str(distelli_num) + "build_log.log"
#f = open(logfile, 'w')

# <<<  run ctest  >>>
cores = '-j2'
test_type = 'quick'
if len(sys.argv) >= 2:
    try:
        ncore = int(sys.argv[1])
    except:
        raise TypeError("Second arguement should be the number of testing cores, default 2")
    cores = '-j' + str(ncore)

if len(sys.argv) >= 3:
    test_type = str(sys.argv[2])

if len(sys.argv) >= 4:
    raise KeyError("Too many inputs for this script!")

if test_type == 'all':
    retcode = subprocess.Popen(['ctest', cores], bufsize=0,
                                stdout=subprocess.PIPE, universal_newlines=True)
else:
    retcode = subprocess.Popen(['ctest', cores, '-L', test_type], bufsize=0,
                                stdout=subprocess.PIPE, universal_newlines=True)
t = time.time()
ctestout = ''
while True:
    data = retcode.stdout.readline()
    if not data:
        break
    sys.stdout.write(data)  # screen
    sys.stdout.flush()
    ctestout += data  # string
#    f.write(data + '\n')

while True:
    retcode.poll()
    exstat = retcode.returncode
    if exstat is not None:
        ctest_exit_status = exstat
        break
    time.sleep(0.1)

#f.close()
ctime = time.time() - t
sys.stdout.write('\n  <<<  Ran test suite in %.3f seconds on %s cores.  >>>\n' % (ctime, str(sys.argv[1])))

# Everything passed woo!
if ctest_exit_status == 0:
    sys.stdout.write("""\n  <<<  All tests passed!  >>>\n\n""")
    sys.exit(ctest_exit_status)

# <<<  identify failed tests and cat their output  >>>
badtests = []
testfail = re.compile(r'^\s*(?P<num>\d+) - (?P<name>\w+(?:-\w+)*) \(Failed\)\s*$')

# Print out failing
sys.stdout.write("""\n  <<<  CTest complete with status %d. Failing outputs follow.  >>>\n\n""" %
                 (ctest_exit_status))

for line in ctestout.split('\n'):
    linematch = testfail.match(line)
    if linematch:
        bad = linematch.group('name')
        badtests.append(bad)
        sys.stdout.write("""\n%s failed. Here is the output:\n""" % (bad))

        badoutfile = bad
        for oddity in ['pcmsolver', 'cfour', 'libefp', 'dmrg', 'dftd3', 'mrcc', 'python', 'psi4numpy']:
            if bad.startswith(oddity):
                badoutfile = oddity + '/' + bad
        badoutfile = 'tests/' + badoutfile + '/output.dat'

        with open(badoutfile, 'r') as ofile:
            sys.stdout.write(ofile.read())

sys.exit(ctest_exit_status)
