#!/Users/github/toolchainconda/bin/python
#!/home/psilocaluser/toolchainconda/bin/python

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

# [LAB 17 Jul 2017]
# Mac gcc conda pkg
#   anaconda copy --to-owner psi4 salford_systems/gcc-5/5.2.0/osx-64/gcc-5-5.2.0-0.tar.bz2

# [LAB 15 Sep 2017]
#   anaconda copy --to-owner psi4 intel/mkl-include/2017.0.3/linux-64/mkl-include-2017.0.3-intel_8.tar.bz2
#   anaconda copy --to-owner psi4 intel/mkl-include/2017.0.3/osx-64/mkl-include-2017.0.3-intel_8.tar.bz2

# [LAB 4 Jan 2018]
# To update setuptools,
#    conda:      4.3.17-py36_0    --> 4.3.30-py36h5d9f9f4_0
#    setuptools: 27.2.0-py36_0    --> 36.4.0-py36_1        

# [LAB 26 Mar 2018]
# Updated all the conda stuff in toolchainconda
#    conda:        4.3.30-py36h5d9f9f4_0 --> 4.5.0-py36_0        
#    conda-build:  3.0.30-py36hc0a0e36_0 --> 3.7.2-py36_0        
#    pycosat:      0.6.1-py36_1          --> 0.6.3-py36h0a5515d_0
#    libgcc-ng:    7.2.0-h7cc24e2_2  --> 7.2.0-hdf63c60_3 
#    libstdcxx-ng: 7.2.0-h7a57d05_2  --> 7.2.0-hdf63c60_3 
#    openssl:      1.0.2m-h26d622b_1 --> 1.0.2n-hb7f436b_0

# [LAB 9 Apr 2018]
#   anaconda copy --to-owner psi4 conda-forge/pybind11/2.2.2/linux-64/pybind11-2.2.2-py36_0.tar.bz2

# [LAB 20 Apr 2018]
#   anaconda copy --to-owner psi4 conda-forge/deepdiff/3.3.0/noarch/deepdiff-3.3.0-py_0.tar.bz2

# [LAB 21 Apr 2018]
#   anaconda copy --to-owner psi4 conda-forge/pybind11/2.2.2/linux-64/pybind11-2.2.2-py35_0.tar.bz2
#   anaconda copy --to-owner psi4 conda-forge/pybind11/2.2.2/linux-64/pybind11-2.2.2-py27_0.tar.bz2

# [LAB 29 Apr 2018]
#   anaconda copy --to-owner psi4 conda-forge/pybind11/2.2.3/linux-64/pybind11-2.2.3-py36_0.tar.bz2
#   anaconda copy --to-owner psi4 conda-forge/pybind11/2.2.3/linux-64/pybind11-2.2.3-py35_0.tar.bz2
#   anaconda copy --to-owner psi4 conda-forge/pybind11/2.2.3/linux-64/pybind11-2.2.3-py27_0.tar.bz2

# [LAB late Apr 2018]
#   remove pb11 2.2.2 from psi4 channel
#   remove mkl-include 2017 linux from psi4 channel

# [LAB 11 May 2018]
#   anaconda copy --to-owner psi4 conda-forge/pybind11/2.2.3/osx-64/pybind11-2.2.3-py36_0.tar.bz2
#   anaconda copy --to-owner psi4 conda-forge/pybind11/2.2.3/osx-64/pybind11-2.2.3-py35_0.tar.bz2
#   anaconda copy --to-owner psi4 conda-forge/pybind11/2.2.3/osx-64/pybind11-2.2.3-py27_0.tar.bz2

# [LAB 14 May 2018]
#   remove c-f noarch copy of deepdiff from psi4 channel, replace with Linux-targeted builds
#   anaconda copy --to-owner psi4 conda-forge/jsonpickle/0.9.6/linux-64/jsonpickle-0.9.6-py27_0.tar.bz2
#   anaconda copy --to-owner psi4 conda-forge/jsonpickle/0.9.6/linux-64/jsonpickle-0.9.6-py35_0.tar.bz2
#   anaconda copy --to-owner psi4 conda-forge/jsonpickle/0.9.6/linux-64/jsonpickle-0.9.6-py36_0.tar.bz2
#   anaconda copy --to-owner psi4 conda-forge/jsonpickle/0.9.6/osx-64/jsonpickle-0.9.6-py36_0.tar.bz2
#   anaconda copy --to-owner psi4 conda-forge/jsonpickle/0.9.6/osx-64/jsonpickle-0.9.6-py35_0.tar.bz2
#   anaconda copy --to-owner psi4 conda-forge/jsonpickle/0.9.6/osx-64/jsonpickle-0.9.6-py27_0.tar.bz2

# [LAB 30 Sep 2018]
#   anaconda copy --to-owner psi4 conda-forge/pint/0.8.1/noarch/pint-0.8.1-py_1.tar.bz2

# [LAB ~31 Jan 2019]
# Linux
#    anaconda-client  1.6.14-py36_0 --> 1.7.2-py36_0
#    conda            4.5.9-py36_0  --> 4.6.2-py36_0
#    conda-build      3.12.0-py36_1 --> 3.17.8-py36_0
# Mac
#    anaconda-client  1.6.14-py36_0 --> 1.7.2-py36_0
#    conda            4.5.4-py36_0  --> 4.6.2-py36_0
#    conda-build      3.10.8-py36_0 --> 3.17.8-py36_0

# [LAB 10 Apr 2019]
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.23/linux-64/pydantic-0.23-py36_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.23/linux-64/pydantic-0.23-py37_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.23/osx-64/pydantic-0.23-py37_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.23/osx-64/pydantic-0.23-py36_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.23/win-64/pydantic-0.23-py36_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.23/win-64/pydantic-0.23-py37_0.tar.bz2
#
# anaconda copy --to-owner psi4 conda-forge/qcelemental/0.3.3/noarch/qcelemental-0.3.3-py_0.tar.bz2

# [LAB 11 Apr 2019]
# anaconda copy --to-owner psi4 conda-forge/qcengine/0.6.4/noarch/qcengine-0.6.4-py_0.tar.bz2

# [LAB 12 Apr 2019]
# anaconda copy --to-owner psi4 conda-forge/dataclasses/0.6/noarch/dataclasses-0.6-py_0.tar.bz2

# [LAB 13 May 2019]
# anaconda copy --to-owner psi4 conda-forge/qcelemental/0.4.0/noarch/qcelemental-0.4.0-py_0.tar.bz2

# [LAB 31 May 2019]
# anaconda copy --to-owner psi4 conda-forge/qcelemental/0.4.1/noarch/qcelemental-0.4.1-py_0.tar.bz2

# [LAB 13 Jun 2019]
# anaconda copy --to-owner psi4 conda-forge/qcelemental/0.4.2/noarch/qcelemental-0.4.2-py_0.tar.bz2

# [LAB 18 Jun 2019]
# anaconda copy --to-owner psi4 conda-forge/qcengine/0.7.1/noarch/qcengine-0.7.1-py_0.tar.bz2

# [LAB 21 Jul 2019]
# anaconda copy --to-owner psi4 conda-forge/qcelemental/0.5.0/noarch/qcelemental-0.5.0-py_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/qcengine/0.8.0/noarch/qcengine-0.8.0-py_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.30.1/linux-64/pydantic-0.30.1-py36h516909a_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.30.1/linux-64/pydantic-0.30.1-py37h516909a_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.30.1/osx-64/pydantic-0.30.1-py36h01d97ff_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.30.1/osx-64/pydantic-0.30.1-py37h01d97ff_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.30.1/win-64/pydantic-0.30.1-py36hfa6e2cd_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.30.1/win-64/pydantic-0.30.1-py37hfa6e2cd_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/qcengine/0.8.1/noarch/qcengine-0.8.1-py_0.tar.bz2

# [LAB 8 Aug 2019]
# anaconda copy --to-owner psi4 conda-forge/pybind11/2.3.0/linux-64/pybind11-2.3.0-py37hc9558a2_1.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pybind11/2.3.0/linux-64/pybind11-2.3.0-py36hc9558a2_1.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pybind11/2.3.0/osx-64/pybind11-2.3.0-py37h770b8ee_1.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pybind11/2.3.0/osx-64/pybind11-2.3.0-py36h770b8ee_1.tar.bz2

# [LAB 13 Aug 2019]
# anaconda copy --to-owner psi4 conda-forge/qcengine/0.8.2/noarch/qcengine-0.8.2-py_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.32.1/win-64/pydantic-0.32.1-py37hfa6e2cd_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.32.1/win-64/pydantic-0.32.1-py36hfa6e2cd_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.32.1/osx-64/pydantic-0.32.1-py36h01d97ff_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.32.1/osx-64/pydantic-0.32.1-py37h01d97ff_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.32.1/linux-64/pydantic-0.32.1-py36h516909a_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/pydantic/0.32.1/linux-64/pydantic-0.32.1-py37h516909a_0.tar.bz2

# [LAB 15 Aug 2019]
# anaconda copy --to-owner psi4 conda-forge/qcelemental/0.6.0/noarch/qcelemental-0.6.0-py_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/qcengine/0.9.0/noarch/qcengine-0.9.0-py_0.tar.bz2

# [LAB 19 Aug 2019]
# anaconda copy --to-owner psi4 conda-forge/qcelemental/0.6.1/noarch/qcelemental-0.6.1-py_0.tar.bz2

# [LAB 26 Aug 2019]
# anaconda copy --to-owner psi4 conda-forge/qcelemental/0.7.0/noarch/qcelemental-0.7.0-py_0.tar.bz2
# anaconda copy --to-owner psi4 conda-forge/qcengine/0.10.0/noarch/qcengine-0.10.0-py_0.tar.bz2

# [LAB 13 Sep 2019]
# anaconda copy --to-owner psi4 conda-forge/qcelemental/0.8.0/noarch/qcelemental-0.8.0-py_0.tar.bz2

import os
import sys
import json
import datetime
import subprocess
from urllib.parse import quote


##
## Build-Box ##  (Data) In this block (and in shebang), define build-box-dependent paths
##
## * good to have an indepdendent miniconda installation (not used in research) for building so can trash. here, "toolchainconda".
## * in the main environment of this miniconda, have installed "conda", "conda-build", and "anaconda-client" packages.
## * similarly, keep the build packages and index outside the miniconda, perhaps in scratch. here, "croot".
## * "dest_subchannel" is where packages uploaded (i.e., "-c psi4/label/dev"). for releases, leave as "dev"
##   and _copy_, not _move_, to "main" via the online interface at Anaconda Cloud
## * leave ".condarc" empty or with harmless show or don't-update-conda commands
##
if sys.platform.startswith('linux'):
    host = "psinet"
    dest_subchannel = 'dev'
    recipe_box = '/home/psilocaluser/gits/psi4meta/conda-recipes'
    croot = '/scratch/psilocaluser/conda-builds'  # formerly CONDA_BLD_PATH
    lenv = {
        'CPU_COUNT': '12',
#        'CPU_COUNT': '1',
        'PATH': '/home/psilocaluser/toolchainconda/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
        }
elif sys.platform == 'darwin':
    host = "macpsinet"
    dest_subchannel = 'dev'
    recipe_box = '/Users/github/Git/psi4meta/conda-recipes'
    croot = '/Users/github/builds/conda-builds'  # formerly CONDA_BLD_PATH
    lenv = {
        'CPU_COUNT': '2',
        'PATH': '/Users/github/toolchainconda/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin',
        }
else:
    sys.exit(1)

cbcy = recipe_box + '/conda_build_config.yaml'
lenv['HOME'] = os.path.expanduser('~')  # dftd3 & Intel license likes a full environment and POSIX guarantees HOME

badgecolors = {
    'NothingNew': '9aa3c4',  # blue
    'Success':    'a3c49a',  # green
    'NoUpload':   'f7f5c1',  # yellow
    'NoFile':     'f7f5c1',  # yellow
    'Local':      'f7f5c1',  # yellow
    'NoBuild':    'c49aa3',  # red
}


##
## Wrap conda-build ## (Code)
##
def _form_channel_command(channel_arg):
    if isinstance(channel_arg, str):
        chan_list = ['-c', channel_arg]
    else:
        chan_list = []
        for chan in channel_arg:
            chan_list.extend(['-c', chan])
        return chan_list

    # if defaults_channel is None:
    return chan_list
    # else:
        # return [(defaults_channel if (c == 'defaults') else c) for c in chan_list]


def _form_python_command(py_arg):
    """Effectively deprecated by conda_build_config.yaml variants"""

    if py_arg is None:
        return []
    elif str(py_arg) in ['2.7', '3.5', '3.6']:
        print('Use conda_build_config.yaml instead!')
        sys.exit(1)
        return ['--python', str(py_arg)]
    else:
        print('Bad Python:', py_arg)
        sys.exit(1)


def _form_extras_command(extras_arg):
    if extras_arg is None:
        return []
    else:
        return extras_arg


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


def wrapped_conda_build(recipe, python=None, keep=False, verbose=True,
                        dest_subchannel='main', build_channels='defaults',
                        envvars=None, cbcy=None, croot=None, cbextras=None,
                        try_to_upload=True):

    pyxx = _form_python_command(python)
    chnls = _form_channel_command(build_channels)
    extras = _form_extras_command(cbextras)

    if envvars:
        lenv.update(envvars)

    # Predict full path with versioned name of conda package
    command = ['conda', 'build', recipe, '--output']
    command.extend(pyxx)
    command.extend(chnls)
    if croot:
        command.extend(['--croot', croot])
    process = subprocess.run(command, env=lenv, cwd=recipe_box, stdout=subprocess.PIPE)
    build_products = process.stdout.decode('utf-8').strip()
    print("""\n  <<<  {} anticipating: {}  >>>""".format(recipe, build_products))
    for bp in build_products.split():
        version = bp.split(recipe)[-1].split('-')[1]

    # Build conda package
    command = ['conda', 'build', recipe]
    command.extend(pyxx)
    command.extend(chnls)
    command.extend(extras)
    if keep:
        command.append('--keep-old-work')
    if cbcy:
        command.extend(['--variant-config-files', cbcy])
    if croot:
        command.extend(['--croot', croot])
    print("""\n  <<<  {} building: {}  >>>\n""".format(recipe, ' '.join(command)))
    build_process = _run_command(command, env=lenv, cwd=recipe_box)
    if build_process != 0:
        return 'NoBuild', version

    # Upload conda package and report package build status
    # * NoBuild --- conda-build failed in build or test
    # * NoFile --- conda package built but package file not found (check if master changed hash during run or croot amiss)
    # * NoUpload --- conda package built but upload rejected b/c already posted or no space
    # * Success --- conda package built and uploaded to anaconda.org
    outcomes = []
    for bp in build_products.split():
        command = ['anaconda', 'upload', bp, '--label', dest_subchannel]
        print("""\n  <<<  {} uploading: {}  >>>\n""".format(recipe, ' '.join(command)))
        if os.path.isfile(bp):
            if try_to_upload:
                upload_process = _run_command(command, env=lenv)
                if upload_process == 0:
                    outcomes.append('Success')
                else:
                    outcomes.append('NoUpload')
            else:
                outcomes.append('Local')
        else:
            outcomes.append('NoFile')
    return outcomes, version


##
## Build Plan ## (Data) Define what to build in this invocation.
##
## * most edits happen in this section. separate for each build box
## * "starred" (***) are the nightly build sequence where psi4/psi4 is changing and psi4 ecosystem constant
## * when committing, all lines except starred should be commented
##
if host == "macpsinet":
	candidates = [

    # Ignore this non-sequenced block
    # -------------------------------
    # qcdb psi4 aka dev1032 --- dest_subchannel = 'nola'
    #{'recipe': 'psi4-nola', 'build_channels': ['psi4/label/dev', 'psi4/label/agg', 'psi4'], 'dest_subchannel': 'nola'},  # qcdb

# starred (***) are nightly build

# M/MISC: order mostly doesn't matter
# -----------------------------------
#{'recipe': 'jsonpickle'},  # neededby: deepdiff, yesarch for constructor (otherwise, c-f)
#{'recipe': 'deepdiff', 'build_channels': ['psi4']},  # chnl: jsonpickle  # neededby: pylibefp, psi4, yesarch for constructor
#{'recipe': 'pybind11'},
#{'recipe': 'sphinx-psi-theme', 'build_channels': ['conda-forge']},  # chnl: cloud_sptheme  # neededby: psi4-docs
#{'recipe': 'openfermion', 'build_channels': ['defaults', 'bioconda']},  # chnl: pubchempy  # neededby: openfermionpsi4
#{'recipe': 'pint'},  # neededby: qcelemental
#{'recipe': 'pnab', 'build_channels': ['conda-forge']},
#{'recipe': 'qcelemental', 'build_channels': ['psi4']},  # chnl: pint  # neededby: psi4

# M/LT: build upstream deps.
#       bump in recipe any upstream versions Psi means to support. rebuild packages.
#       upon any failure, adjust source of Psi & upstream.
# ----------------------------------------------------------------------------------
#{'recipe': 'ambit'},
#{'recipe': 'chemps2-multiout'},
#{'recipe': 'cppe', 'build_channels': ['psi4/label/dev']},  # chnl: pybind11
#{'recipe': 'dkh'},
#{'recipe': 'erd'},
#{'recipe': 'gau2grid-multiout'},
#{'recipe': 'gdma'},
#{'recipe': 'libint'},
#{'recipe': 'pcmsolver'},
#{'recipe': 'simint'},
#{'recipe': 'libxc'},

# M/CBCY1: if anything in LT changed, edit cbcy.
#          start new ltrtver line and bump versions in "ltrtver" table & "<addon>" entries.
#          good idea to edit target (& if warranted, min) in psi4 repo at this time.
# -----------------------------------------------------------------------------------------

# M/PSI4: build Psi4 w/o any RT deps or tests (***)
# -------------------------------------------------
{'recipe': 'psi4-multiout', 'build_channels': ['psi4/label/dev']},

# M/RT-MP: build RT metapackage w/existing downstreams and new Psi4 (***)
#          upon any failure, step back (preferred), adjusting source of Psi to fix Psi+downstream interface
#                       -OR- step forward, rebuilding downstream against new Psi ABI or adjusting source of downstream.
#          upon success, continue at M/DEV.
# ---------------------------------------------------------------------------------------------------------------------
{'recipe': 'psi4-rt', 'build_channels': ['psi4/label/dev']},

# M/RT: if psi4-rt tests fail, build the downstreams as needed.
# -------------------------------------------------------------
#{'recipe': 'libefp-multiout', 'build_channels': ['psi4/label/dev']},  # chnl: qcel, pb11
#{'recipe': 'dftd3'},
#{'recipe': 'gcp'},
# 'resp' converted to noarch Aug 2019, so builds on L
#{'recipe': 'snsmp2', 'build_channels': ['psi4/label/dev', 'psi4']},  # chnl: psi4
#{'recipe': 'v2rdm', 'build_channels': ['psi4/label/dev', 'psi4']},  # chnl: psi4
#{'recipe': 'openfermionpsi4', 'build_channels': ['psi4/label/dev']},  # chnl: openfermion, psi4
#{'recipe': 'mp2d'},

# M/CBCY2: if anything in RT changed, edit cbcy.
#          start or continue editing new ltrtver line and bump versions in "ltrtver" table & "<addon>" entries.
#          return to M/RT-MP.
# -------------------------------------------------------------------------------------------------------------

# M/DEV: build the deps package and test `psi4-path-advisor` (***)
# ----------------------------------------------------------------
{'recipe': 'psi4-dev', 'build_channels': ['psi4/label/dev', 'psi4']},
		]


if host == "psinet":
    candidates = [

    # Ignore this non-sequenced block
    # -------------------------------
    #{'recipe': 'lawrap'},  # linux
    #{'recipe': 'erd'},

    # CBCY openblas --- dest_subchannel = 'nomkl'
    #{'recipe': 'chemps2-multiout', 'dest_subchannel': 'nomkl'},
    #{'recipe': 'libefp-multiout', 'build_channels': ['psi4'], 'dest_subchannel': 'nomkl'},  # deepdiff, pb11 from psi4
    #{'recipe': 'psi4-multiout', 'build_channels': ['psi4/label/nomkl', 'psi4/label/dev', 'psi4'], 'dest_subchannel': 'nomkl'},

    # qcdb psi4 aka dev1032 --- dest_subchannel = 'nola'
    #{'recipe': 'psi4-multiout', 'build_channels': ['psi4/label/dev', 'psi4'], 'dest_subchannel': 'nola'},  # qcdb

# starred (***) are nightly build

# L/MISC: order mostly doesn't matter
# -----------------------------------
#{'recipe': 'ci-psi4'},  # neededby: CI for up/downstream
#{'recipe': 'jsonpickle'},  # neededby: deepdiff, yesarch for constructor (otherwise, c-f)
#{'recipe': 'deepdiff', 'build_channels': ['psi4']},  # chnl: jsonpickle  # neededby: pylibefp, psi4, yesarch for constructor
#{'recipe': 'pybind11'},
#{'recipe': 'pytest-shutil', 'build_channels': ['defaults', 'conda-forge']},  # chnl: setuptools-git  # neededby: v2rdm  # Note: recipe fine but useless as c-b & pytest-shutil don't mix
#{'recipe': 'sphinx-psi-theme', 'build_channels': ['conda-forge']},  # chnl: cloud_sptheme  # neededby: psi4-docs
#{'recipe': 'openfermion', 'build_channels': ['defaults', 'bioconda']},  # chnl: pubchempy  # neededby: openfermionpsi4
#{'recipe': 'pint'},  # neededby: qcelemental
#{'recipe': 'qcelemental', 'build_channels': ['psi4']},  # chnl: pint  # neededby: psi4
#{'recipe': 'helpme'},  #, 'build_channels': ['psi4']},  # chnl: pybind11
#{'recipe': 'pnab', 'build_channels': ['conda-forge']},

# L/LT: build upstream deps.
#       bump in recipe any upstream versions Psi means to support. rebuild packages.
#       upon any failure, adjust source of Psi & upstream.
# ----------------------------------------------------------------------------------
#{'recipe': 'ambit'},
#{'recipe': 'chemps2-multiout'},
#{'recipe': 'cppe', 'build_channels': ['psi4/label/dev']},  # chnl: pybind11
#{'recipe': 'dkh'},
#{'recipe': 'gau2grid-multiout'},
###{'recipe': 'gau2grid-multiout', 'build_channels': ['conda-forge']},  # c-f prep
#{'recipe': 'gdma'},
#{'recipe': 'libint'},
#{'recipe': 'pcmsolver'},
#{'recipe': 'simint'},
#{'recipe': 'libxc'},

# L/CBCY1: if anything in LT changed, edit cbcy.
#          start new ltrtver line and bump versions in "ltrtver" table & "<addon>" entries.
#          good idea to edit target (& if warranted, min) in psi4 repo at this time.
# -----------------------------------------------------------------------------------------

# L/PSI4: build Psi4 w/o any RT deps or tests (***)
# -------------------------------------------------
{'recipe': 'psi4-multiout', 'build_channels': ['psi4/label/dev']},

# L/RT-MP: build RT metapackage w/existing downstreams and new Psi4 (***)
#          upon any failure, step back (preferred), adjusting source of Psi to fix Psi+downstream interface
#                       -OR- step forward, rebuilding downstream against new Psi ABI or adjusting source of downstream.
#          upon success, continue at L/DEV.
# ---------------------------------------------------------------------------------------------------------------------
{'recipe': 'psi4-rt', 'build_channels': ['psi4/label/dev']},

# L/RT: if psi4-rt tests fail, build the downstreams as needed.
# -------------------------------------------------------------
#{'recipe': 'libefp-multiout', 'build_channels': ['psi4/label/dev']}, #, 'defaults', 'conda-forge']},  # chnl: qcel, pb11, docs-stuff
#{'recipe': 'dftd3'},
#{'recipe': 'gcp'},
#{'recipe': 'gpudfcc', 'build_channels': ['psi4/label/dev']},  # chnl: psi4
#{'recipe': 'resp', 'build_channels': ['psi4/label/dev']},  # chnl: psi4
#{'recipe': 'snsmp2', 'build_channels': ['psi4/label/dev']},  # chnl: psi4
#{'recipe': 'v2rdm', 'build_channels': ['psi4/label/dev']},  # chnl: psi4
#{'recipe': 'openfermionpsi4', 'build_channels': ['psi4/label/dev']},  # chnl: openfermion, psi4
#{'recipe': 'mp2d'},
#{'recipe': 'postg'},

# L/CBCY2: if anything in RT changed, edit cbcy.
#          start or continue editing new ltrtver line and bump versions in "ltrtver" table & "<addon>" entries.
#          return to L/RT-MP.
# -------------------------------------------------------------------------------------------------------------

# L/DEV: build the deps package and test `psi4-path-advisor` (***)
# ----------------------------------------------------------------
{'recipe': 'psi4-dev', 'build_channels': ['psi4/label/dev']},

# L/DOCS: build the docs, feed, and doxygen targets and run coverage (***)
# ------------------------------------------------------------------------
{'recipe': 'psi4-docs', 'build_channels': ['psi4/label/dev', 'defaults', 'conda-forge'], 'cbextras': ['--prefix-length', '100']},  # chnl: cov*, docs*
        ]


##
## Loop conda-build ##  (Code) Build all un-commented packages in Build Plan
##
dependent_sequence = True  # T for (***)
try_to_upload = True
for kw in candidates:
    time_string = datetime.datetime.now().strftime('%A, %d %B %Y %I:%M%p')
    print("""\n  <<<  {} starting: {}  >>>""".format(kw['recipe'], time_string))

    dst = kw.pop('dest_subchannel', dest_subchannel)
    ans, ver = wrapped_conda_build(verbose=True,
                              keep=True,
                              dest_subchannel=dst,
                              cbcy=cbcy,
                              croot=croot,
                              try_to_upload=try_to_upload,
                              **kw)

    time_string = datetime.datetime.now().strftime('%A, %d %B %Y %I:%M%p')
    print("""\n  <<<  {} finishing: {}  >>>""".format(kw['recipe'], time_string))
    print("""\n  <<<  {} final disposition: {}  >>>\n""".format(kw['recipe'], ans))

    if isinstance(ans, str):
        ans = [ans]
    shieldsio = {
        "schemaVersion": 1,
        "label": quote(kw['recipe']),
        "message": ver,
        "color": badgecolors[ans[-1]],
        "namedLogo": {"macpsinet": 'apple', "psinet": "linux"}[host],
        "logoColor": "white",
        "isError": "true",
    }
    with open(recipe_box + f'/../psicode_dropbox/shieldsio_{host}_{kw["recipe"]}.json', 'w') as fp:
        json.dump(shieldsio, fp)

    if dependent_sequence and not all([(outcome in ['NoUpload', 'Success']) for outcome in ans]):
        print("""\n  <<<  Poodle has halted.  >>>\n""")
        break
else:
    print("""\n  <<<  Poodle has finished cleanly.  >>>\n""")


#conda build v2rdm -c http://conda.anaconda.org/psi4/label/test -c http://conda.anaconda.org/psi4 --python 3.5
# CONDA_BLD_PATH=/scratch/psilocaluser/conda-builds/ /home/psilocaluser/bldmconda3/bin/conda build purge

# constructor --platform linux-64 psi4-installer/
# constructor --platform osx-64 psi4-installer/
# scp -r psi4conda-1.1rc1-py* root@vergil.chemistry.gatech.edu:/var/www/html/download/
