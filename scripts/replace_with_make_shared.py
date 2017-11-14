# coding=utf8
# the above tag defines encoding for this document and is for Python 2.x compatibility
# Note: for Python 2.7 compatibility, use ur'' to prefix the regex and u"" to prefix the test string and substitution.ase1_regex =

import glob
import itertools
import os
import re
import shutil
import tempfile

# First pass
regex1 = r'([a-zA-Z:_<>0-9]+) ([a-zA-Z:_<>0-9]+)\s?\(new ([a-zA-Z:_<>0-9]+)\((.*)\)\);'
repl1 = r'\1 \2 = std::make_shared<\3>(\4);'
for fname in itertools.chain(glob.iglob('**/*.cc', recursive=True), glob.iglob('**/*.h', recursive=True)):
    tmpdir = tempfile.gettempdir()
    tmpfil = os.path.join(tmpdir, os.path.basename(fname) + '.bak')
    shutil.copy2(fname, tmpfil)
    with open(tmpfil, 'r') as tmp:
        inpt = tmp.readlines()
        output = []
        print(('Pass 1: replacing new with std::make_shared in {}'.format(fname)))
        output.extend([re.sub(regex1, repl1, x) for x in inpt])
        if output:
            try:
                f = open(fname, 'w')
                f.writelines(output)
            except IOError as err:
                print(('Pass 1: something went wrong trying to handle {}: {}'.format(fname, err)))
            finally:
                f.close()
        os.remove(tmpfil)

# Second pass
regex2 = r'([a-zA-Z:_<>0-9]+) = ([a-zA-Z:_<>0-9]+)\s?\(new ([a-zA-Z:_<>0-9]+)\((.*)\)\);'
repl2 = r'\1 = std::make_shared<\3>(\4);'
for fname in itertools.chain(glob.iglob('**/*.cc', recursive=True), glob.iglob('**/*.h', recursive=True)):
    tmpdir = tempfile.gettempdir()
    tmpfil = os.path.join(tmpdir, os.path.basename(fname) + '.bak')
    shutil.copy2(fname, tmpfil)
    with open(tmpfil, 'r') as tmp:
        inpt = tmp.readlines()
        output = []
        print(('Pass 2: replacing new with std::make_shared in {}'.format(fname)))
        output.extend([re.sub(regex2, repl2, x) for x in inpt])
        if output:
            try:
                f = open(fname, 'w')
                f.writelines(output)
            except IOError as err:
                print(('Pass 2: something went wrong trying to handle {}: {}'.format(fname, err)))
            finally:
                f.close()
        os.remove(tmpfil)

# Third pass
regex3 = r'([a-zA-Z:_<>0-9]+)\s?\(new ([a-zA-Z:_<>0-9]+)\((.*)\)\);'
repl3 = r'std::make_shared<\2>(\3);'
for fname in itertools.chain(glob.iglob('**/*.cc', recursive=True), glob.iglob('**/*.h', recursive=True)):
    tmpdir = tempfile.gettempdir()
    tmpfil = os.path.join(tmpdir, os.path.basename(fname) + '.bak')
    shutil.copy2(fname, tmpfil)
    with open(tmpfil, 'r') as tmp:
        inpt = tmp.readlines()
        output = []
        print(('Pass 3: replacing new with std::make_shared in {}'.format(fname)))
        output.extend([re.sub(regex3, repl3, x) for x in inpt])
        if output:
            try:
                f = open(fname, 'w')
                f.writelines(output)
            except IOError as err:
                print(('Pass 3: something went wrong trying to handle {}: {}'.format(fname, err)))
            finally:
                f.close()
        os.remove(tmpfil)
