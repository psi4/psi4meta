#!/home/psilocaluser/bldmconda3/bin/python

#/usr/bin/env python3

# [LAB 4 Apr 2017]
# Adapt for Mac and Linux
# Separate psi4-core dest_channel from other defaults

# [LAB 24 Mar 2017]
# Confirmed a nightly build set
# Outputs stdout in real time
# Working for Mac now too

# [LAB 22 Mar 2017]
# Translated accumulated notes and aspects of kitandkaboodle to python
# Started new bld miniconda with shorter prefix and py36 (<-- py27)

# [LAB 9 May 2017]
# Switched nightly build channel to dev (<-- devel)
# merged mac/linux targets

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
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, **kw)

    while True:
        output = process.stdout.readline()
        if output == b'' and process.poll() is not None:
            break
        if output:
            sys.stdout.write(output.decode('utf-8'))
            sys.stdout.flush()
    rc = process.poll()
    return rc


if sys.platform.startswith('linux'):
    host = "psinet"
    dest_subchannel = 'main'
    psi4_dest_subchannel = 'dev'
    recipe_box = '/home/psilocaluser/gits/psi4meta/conda-recipes'
    lenv = {
        'CPU_COUNT': '8',
        'CONDA_BLD_PATH': '/scratch/psilocaluser/conda-builds',
        'PATH': '/home/psilocaluser/bldmconda3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
        }

elif sys.platform == 'darwin':
    host = "macpsinet"
    dest_subchannel = 'main'
    psi4_dest_subchannel = 'dev'
    recipe_box = '/Users/github/Git/psi4meta/conda-recipes'
    lenv = {
        'CPU_COUNT': '2',
        'CONDA_BLD_PATH': '/Users/github/builds/conda-builds',
        'PATH': '/Users/github/bldmconda3/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin',
        }

else:
    sys.exit(1)


def wrapped_conda_build(recipe, python=None, keep=False, verbose=True,
                        dest_subchannel='main', build_channels='defaults'):

    pyxx = _form_python_command(python)
    chnls = _form_channel_command(build_channels)

    # Predict full path with versioned name of conda package
    command = ['conda', 'build', recipe, '--output']
    command.extend(pyxx)
    build_product = subprocess.Popen(command, env=lenv, cwd=recipe_box,
                                     stdout=subprocess.PIPE).stdout.read().decode('utf-8').strip()
    print("""\n  <<<  {} anticipating: {}  >>>""".format(recipe, build_product))

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
#{'recipe': 'chemps2', 'build_channels': ['psi4']},
#{'recipe': 'pychemps2', 'python': '2.7', 'build_channels': ['psi4']},
#{'recipe': 'pychemps2', 'python': '3.5', 'build_channels': ['psi4']},
#{'recipe': 'pychemps2', 'python': '3.6', 'build_channels': ['psi4']},
#{'recipe': 'dkh', 'build_channels': 'psi4'},  # not yet built on mac
#{'recipe': 'libefp', 'build_channels': 'psi4'},  # mac doesn't need b_c:psi4
#{'recipe': 'erd', 'build_channels': 'psi4'},  # not yet built on mac
#{'recipe': 'gdma', 'build_channels': 'psi4'},
#{'recipe': 'am7-mp'},
#{'recipe': 'am8-mp'},
#{'recipe': 'libint'},  # toggle recipes for AM feature
#{'recipe': 'pcmsolver', 'python': '2.7', 'build_channels': 'psi4'},  # mac doesn't need b_c:psi4
#{'recipe': 'pcmsolver', 'python': '3.5', 'build_channels': 'psi4'},  # mac doesn't need b_c:psi4
#{'recipe': 'pcmsolver', 'python': '3.6', 'build_channels': 'psi4'},  # mac doesn't need b_c:psi4
#{'recipe': 'simint'},

#{'recipe': 'dftd3'},  # not yet built on mac
#{'recipe': 'gcp'},  # not yet built on mac
#{'recipe': 'v2rdm', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']},  # had been test/clang
#{'recipe': 'v2rdm', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4']},  # had been test/clang
#{'recipe': 'v2rdm', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']},  # had been test/clang

#{'recipe': 'psi4-rt', 'python': '2.7', 'build_channels': 'psi4'},
#{'recipe': 'psi4-rt', 'python': '3.5', 'build_channels': 'psi4'},
#{'recipe': 'psi4-rt', 'python': '3.6', 'build_channels': 'psi4'},
#{'recipe': 'psi4-lt-mp', 'python': '2.7', 'build_channels': 'psi4'},
#{'recipe': 'psi4-lt-mp', 'python': '3.5', 'build_channels': 'psi4'},
#{'recipe': 'psi4-lt-mp', 'python': '3.6', 'build_channels': 'psi4'},
#{'recipe': 'psi4-dev', 'python': '2.7', 'build_channels': 'psi4'},
#{'recipe': 'psi4-dev', 'python': '3.5', 'build_channels': 'psi4'},
#{'recipe': 'psi4-dev', 'python': '3.6', 'build_channels': 'psi4'},
                 ]

if host == "psinet":
    candidates.append({'recipe': 'psi4-core', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']})
    candidates.append({'recipe': 'psi4-core', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4', 'defaults', 'conda-forge']})
    candidates.append({'recipe': 'psi4-core', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']})
    pass
if host == "macpsinet":
    candidates.append({'recipe': 'psi4-core', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']})
    candidates.append({'recipe': 'psi4-core', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4']})
    candidates.append({'recipe': 'psi4-core', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']})
    pass
# psi4/label/dev above catches addon updates not suitable for 1.1 release (i.e., v2rdm)

for kw in candidates:
    time_string = datetime.datetime.now().strftime('%A, %d %B %Y %I:%M%p')
    print("""\n  <<<  {} starting: {}  >>>""".format(kw['recipe'], time_string))
    dst = psi4_dest_subchannel if kw['recipe'] == 'psi4-core' else dest_subchannel
    ans = wrapped_conda_build(verbose=True, keep=False, dest_subchannel=dst, **kw)
    time_string = datetime.datetime.now().strftime('%A, %d %B %Y %I:%M%p')
    print("""\n  <<<  {} finishing: {}  >>>""".format(kw['recipe'], time_string))
    print("""\n  <<<  {} final disposition: {}  >>>\n""".format(kw['recipe'], ans))

#conda build v2rdm -c http://conda.anaconda.org/psi4/label/test -c http://conda.anaconda.org/psi4 --python 3.5
# CONDA_BLD_PATH=/scratch/psilocaluser/conda-builds/ /home/psilocaluser/bldmconda3/bin/conda build purge

#conda create -n tp4deps35 python=3.5 psi4-deps -c psi4/label/test -c psi4
#conda create -n tp4deps35 python=3.5 psi4-deps -c psi4

# # packages in environment at /home/psilocaluser/bldmconda3:
# anaconda-client           1.6.2                    py36_0
# conda                     4.3.16                   py36_0
# conda-build               2.1.9                    py36_0
# conda-env                 2.6.0                         0
# conda-verify              2.0.0                    py36_0
# constructor               1.5.5                    py36_0
# libconda                  4.0.0                    py36_0
# python                    3.6.1                         0
# python-dateutil           2.6.0                    py36_0

# 8 May 2017
#    Linux
#    anaconda-client: 1.6.2-py36_0  --> 1.6.3-py36_0 
#    conda:           4.3.16-py36_0 --> 4.3.17-py36_0
#    Mac
#    anaconda-client: 1.6.2-py36_0 defaults --> 1.6.3-py36_0 defaults

# # packages in environment at /Users/github/bldmconda3:
# anaconda-client           1.6.2                    py36_0    defaults
# conda                     4.3.14                   py36_0    defaults
# conda-build               2.1.8                    py36_0    defaults
# conda-env                 2.6.0                         0    defaults
# conda-verify              2.0.0                    py36_0    defaults
# constructor               1.5.4                    py36_0    defaults
# libconda                  4.0.0                    py36_0    defaults
# python                    3.6.0                         0    defaults
# python-dateutil           2.6.0                    py36_0    defaults

# constructor --platform linux-64 psi4-installer/
# constructor --platform osx-64 psi4-installer/
# scp -r psi4conda-1.1rc1-py* root@vergil.chemistry.gatech.edu:/var/www/html/download/
