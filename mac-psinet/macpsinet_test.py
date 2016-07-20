#!/usr/bin/env python
import re
import sys
import time
import subprocess

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
    #tciout.write(data)  # file
    #tciout.flush()
    ctestout += data  # string
while True:
    retcode.poll()
    exstat = retcode.returncode
    if exstat is not None:
        ctest_exit_status = exstat
        break
    time.sleep(0.1)

ctime = time.time() - t
sys.stdout.write('\n  <<<  Ran test suite in %.3f seconds on %d cores.  >>>\n' % (ctime, sys.argv[2]))

# <<<  identify failed tests and cat their output  >>>
sys.stdout.write("""\n  <<<  CTest complete with status %d. Failing outputs follow.  >>>\n\n""" %
                 (ctest_exit_status))
badtests = []
testfail = re.compile(r'^\s*(?P<num>\d+) - (?P<name>\w+(?:-\w+)*) \(Failed\)\s*$')

for line in ctestout.split('\n'):
    linematch = testfail.match(line)
    if linematch:
        bad = linematch.group('name')
        sys.stdout.write("""\n%s failed. Here is the output:\n""" % (bad))

        badoutfile = bad
        for oddity in ['pcmsolver', 'cfour', 'libefp', 'dmrg', 'dftd3', 'mrcc']:
            if bad.startswith(oddity):
                badoutfile = oddity + '/' + bad
        badoutfile = 'tests/' + badoutfile + '/output.dat'

        with open(badoutfile, 'r') as ofile:
            sys.stdout.write(ofile.read())

# <<<  return ctest error code  >>>
sys.exit(ctest_exit_status)
