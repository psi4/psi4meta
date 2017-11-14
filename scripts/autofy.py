# coding=utf8
# the above tag defines encoding for this document and is for Python 2.x compatibility
# Note: for Python 2.7 compatibility, use ur'' to prefix the regex and u"" to prefix the test string and substitution.ase1_regex =

import glob
import itertools
import os
import re
import shutil
import tempfile

regex = r'(?:([a-zA-Z0-9<>_:]+)) ([a-zA-Z0-9<>_:]+) = std::make_shared<([a-zA-Z0-9<>_:]+)>\((.*)\);'
repl = r'auto \2 = std::make_shared<\3>(\4);'
for fname in itertools.chain(glob.iglob('**/*.cc', recursive=True), glob.iglob('**/*.h', recursive=True)):
    tmpdir = tempfile.gettempdir()
    tmpfil = os.path.join(tmpdir, os.path.basename(fname) + '.bak')
    shutil.copy2(fname, tmpfil)
    with open(tmpfil, 'r') as tmp:
        inpt = tmp.readlines()
        output = []
        print(('Replacing LHS type with auto in {}'.format(fname)))
        output.extend([re.sub(regex, repl, x) for x in inpt])
        if output:
            try:
                f = open(fname, 'w')
                f.writelines(output)
            except IOError as err:
                print(('Something went wrong trying to handle {}: {}'.format(fname, err)))
            finally:
                f.close()
        os.remove(tmpfil)
