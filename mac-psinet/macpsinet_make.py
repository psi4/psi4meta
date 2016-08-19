#!/usr/bin/env python
import sys
import time
import subprocess as sp


cores = 4
sys.stdout.write('\n  <<<  Building Psi4 on psinet on %d cores.  >>>\n\n\n' % cores)

t = time.time()
# Build a run object
retcode = sp.Popen(['make', '-j' + str(cores)], bufsize=0, stderr=sp.STDOUT,
                            stdout=sp.PIPE, universal_newlines=True)

# Parse the output
ctestout = ''
while True:
    data = retcode.stdout.readline()
    if not data:
        break

    # Only print a bit out
    if 'Built' in data:
        sys.stdout.write(data)  # screen

    ctestout += data  # string

# Did we finish?
while True:
    retcode.poll()
    exstat = retcode.returncode
    if exstat is not None:
        ctest_exit_status = exstat
        break
    time.sleep(0.1)

ctime = time.time() - t
sys.stdout.write('\n  <<<  Psi4 built in %.3f seconds on %d cores.  >>>\n' % (ctime, cores))

# If we didnt make it, print some info
if ctest_exit_status:
    sys.stdout.write('\n  <<<  Build has failed, last 500 lines of output.  >>>\n\n\n')
    lastout = ctestout.splitlines()[-500:]
    sys.stdout.write('\n'.join(lastout))
    sys.stdout.write('\n')
    sys.stdout.write('\n  <<<  Build has failed!  >>>\n\n\n')

# Celebrate and set the rpath because I suck
else:
    sys.stdout.write('\n  <<<  Psi4 has built successfully!!  >>>\n\n\n')
    sp.call('install_name_tool -change "@rpath/libpython2.7.dylib" "/Users/github/anaconda/lib/libpython2.7.dylib" bin/psi4', shell=True)

# <<<  return ctest error code  >>>
sys.exit(ctest_exit_status)

