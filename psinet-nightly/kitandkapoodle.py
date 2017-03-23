#!/theoryfs2/ds/cdsgroup/bldmconda3/bin/python

#/usr/bin/env python3

# [LAB 22 Mar 2017]
# Translated accumulated notes and aspects of kitandkaboodle to python
# Started new bld miniconda with shorter prefix and py36 (<-- py27)

import os
import sys
import datetime
import subprocess


def _form_channel_command(channel_arg):
    if isinstance(channel_arg, str):
        return ['-c', channel_arg]
    else:
        chan_list = []
        for chan in channel_arg:
            chan_list.extend(['-c', chan])
        return chan_list


def _form_python_command(py_arg):
    if py_arg is None:
        return []
    elif str(py_arg) in ['2.7', '3.5', '3.6']:
        return ['--python', str(py_arg)]
    else:
        print('Bad Python:', py_arg)
        sys.exit(1)


def _run_command(command, env=None, cwd=None):
    kw = {}
    if env is not None:
        kw['env'] = env
    if cwd is not None:
        kw['cwd'] = cwd
    process = subprocess.Popen(command, stdout=subprocess.PIPE, **kw)

    while True:
        output = process.stdout.readline()
        if output == b'' and process.poll() is not None:
            break
        if output:
            print(output.decode('utf-8').strip())
    rc = process.poll()
    return rc


recipe_box = """/theoryfs2/ds/cdsgroup/psi4-compile/psi4meta/conda-recipes"""
lenv = {
    #'PATH': """/theoryfs2/ds/cdsgroup/buildingminiconda/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin""",
    'PATH': """/theoryfs2/ds/cdsgroup/bldmconda3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin""",
    'CONDA_BLD_PATH': """/scratch/cdsgroup/conda-builds""",  # fixed in conda 4.2.13
    'CPU_COUNT': '4',
    }


def build_it(recipe, python=None, keep=False, verbose=True,
             dest_subchannel='main', build_channels='defaults'):

    pyxx = _form_python_command(python)
    chnls = _form_channel_command(build_channels)

    # Predict full path with versioned name of conda package
    command = ['conda', 'build', recipe, '--output']
    command.extend(pyxx)
    build_product = subprocess.Popen(command, env=lenv, cwd=recipe_box,
                                     stdout=subprocess.PIPE).stdout.read().decode('utf-8').strip()
    print("""\n  <<<  {} commencing: {}  >>>""".format(recipe, build_product))

    # Build conda package
    command = ['conda', 'build', recipe]
    command.extend(pyxx)
    command.extend(chnls)
    if keep:
        command.append('--keep-old-work')
    print("""\n  <<<  {} building: {}  >>>\n""".format(recipe, ' '.join(command)))
    build_process = _run_command(command, env=lenv, cwd=recipe_box)
    if build_process != 0:
        return 'NoBuild'

    # Upload conda package
    if os.path.isfile(build_product):
        command = ['anaconda', 'upload', build_product, '--label', dest_subchannel]
        print("""\n  <<<  {} uploading: {}  >>>\n""".format(recipe, ' '.join(command)))
        upload_process = _run_command(command, env=lenv)
        if upload_process == 0:
            return 'Success'
        else:
            return 'NoUpload'
    else:
        return 'NoFile'


candidates = [
{'recipe': 'psi4-core', 'python': '2.7', 'build_channels': ['psi4/label/test', 'psi4', 'defaults']},
{'recipe': 'psi4-core', 'python': '3.5', 'build_channels': ['psi4/label/test', 'psi4', 'defaults', 'conda-forge']},
{'recipe': 'psi4-core', 'python': '3.6', 'build_channels': ['psi4/label/test', 'psi4', 'defaults']},
###{'recipe': 'chemps2', 'build_channels': ['psi4']},
###{'recipe': 'pychemps2', 'python': '2.7', 'build_channels': ['psi4']},
###{'recipe': 'pychemps2', 'python': '3.5', 'build_channels': ['psi4']},
###{'recipe': 'pychemps2', 'python': '3.6', 'build_channels': ['psi4']},
###{'recipe': 'libefp', 'build_channels': 'psi4'},
###{'recipe': 'erd', 'build_channels': 'psi4'},
###{'recipe': 'dkh', 'build_channels': 'psi4'},
###{'recipe': 'gdma', 'build_channels': 'psi4'},
###{'recipe': 'simint'},
###{'recipe': 'pcmsolver', 'python': '2.7', 'build_channels': 'psi4'},
###{'recipe': 'pcmsolver', 'python': '3.5', 'build_channels': 'psi4'},
###{'recipe': 'pcmsolver', 'python': '3.6', 'build_channels': 'psi4'},
]

for kw in candidates:
    time_string = datetime.datetime.now().strftime('%A, %d %B %Y %I:%M%p')
    print("""\n  <<<  {} starting: {}  >>>""".format(kw['recipe'], time_string))
    ans = build_it(verbose=True, keep=False, dest_subchannel='test', **kw)
    time_string = datetime.datetime.now().strftime('%A, %d %B %Y %I:%M%p')
    print("""\n  <<<  {} finishing: {}  >>>""".format(kw['recipe'], time_string))
    print("""\n  <<<  {} final disposition: {}  >>>\n""".format(kw['recipe'], ans))

#conda build v2rdm -c http://conda.anaconda.org/psi4/label/test -c http://conda.anaconda.org/psi4 --python 3.5
#conda build pdoc -c conda-forge -c psi4/label/test -c psi4 --python 3.5
# CONDA_BLD_PATH=/scratch/cdsgroup/conda-builds/ conda build purge

        #upload_process = subprocess.Popen(command,
        #                                  stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
        #for data in iter(upload_process.stdout.readline, ""):
        #    sys.stdout.write(data)
