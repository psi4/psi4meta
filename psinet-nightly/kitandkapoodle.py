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


if sys.platform.startswith('linux'):
    host = "psinet"
    #dest_subchannel = 'agg'
    dest_subchannel = 'dev'
    #dest_subchannel = 'main'
    recipe_box = '/home/psilocaluser/gits/psi4meta/conda-recipes'
    cbcy = recipe_box + '/conda_build_config.yaml'
    lenv = {
        'CPU_COUNT': '12',
        'CONDA_BLD_PATH': '/scratch/psilocaluser/conda-builds',
        'PATH': '/home/psilocaluser/toolchainconda/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
        }

elif sys.platform == 'darwin':
    host = "macpsinet"
    dest_subchannel = 'dev'
    #dest_subchannel = 'agg'
    recipe_box = '/Users/github/Git/psi4meta/conda-recipes'
    cbcy = recipe_box + '/conda_build_config.yaml'
    lenv = {
        'CPU_COUNT': '2',
        'CONDA_BLD_PATH': '/Users/github/builds/conda-builds',
        'PATH': '/Users/github/toolchainconda/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin',
        }

else:
    sys.exit(1)


def wrapped_conda_build(recipe, python=None, keep=False, verbose=True,
                        dest_subchannel='main', build_channels='defaults',
                        envvars=None, cbcy=None, cbextras=None):

    pyxx = _form_python_command(python)
    chnls = _form_channel_command(build_channels)
    extras = _form_extras_command(cbextras)

    if envvars:
        lenv.update(envvars)

    # Predict full path with versioned name of conda package
    command = ['conda', 'build', recipe, '--output']
    command.extend(pyxx)
    command.extend(chnls)
    build_products = subprocess.Popen(command, env=lenv, cwd=recipe_box,
                                     stdout=subprocess.PIPE).stdout.read().decode('utf-8').strip()
    print("""\n  <<<  {} anticipating: {}  >>>""".format(recipe, build_products))

    # Build conda package
    command = ['conda', 'build', recipe]
    command.extend(pyxx)
    command.extend(chnls)
    command.extend(extras)
    if keep:
        command.append('--keep-old-work')
    if cbcy:
        command.append('--variant-config-files')
        command.append(cbcy)
    print("""\n  <<<  {} building: {}  >>>\n""".format(recipe, ' '.join(command)))
    build_process = _run_command(command, env=lenv, cwd=recipe_box)
    if build_process != 0:
        return 'NoBuild'

    # Upload conda package
    outcomes = []
    for bp in build_products.split():
        command = ['anaconda', 'upload', bp, '--label', dest_subchannel]
        print("""\n  <<<  {} uploading: {}  >>>\n""".format(recipe, ' '.join(command)))
        if os.path.isfile(bp):
            upload_process = _run_command(command, env=lenv)
            if upload_process == 0:
                outcomes.append('Success')
            else:
                outcomes.append('NoUpload')
        else:
            outcomes.append('NoFile')
    return outcomes


if host == "macpsinet":
	candidates = [

# starred (***) are nightly build

# M/MISC: order mostly doesn't matter
# -----------------------------------
#{'recipe': 'deepdiff', 'build_channels': ['conda-forge']},  # chnl: jsonpickle  # neededby: pylibefp, psi4, yesarch for constructor

# M/LT: bump in recipe any upstream versions Psi means to support and rebuild
#       upon any failure, adjust source of Psi & upstream
# ---------------------------------------------------------------------------
#{'recipe': 'ambit'},
#{'recipe': 'chemps2-multiout'},
#{'recipe': 'dkh'},
#{'recipe': 'libefp-multiout', 'build_channels': ['psi4']},  # chnl: deepdiff, pb11
#{'recipe': 'erd'},
#{'recipe': 'gau2grid-multiout'},
#{'recipe': 'gdma'},
#{'recipe': 'libint'},
#{'recipe': 'pcmsolver'},
#{'recipe': 'simint'},
#{'recipe': 'libxc'},

# M/CBCY: edit "ltrtver" & "<addon>" if anything in LT changed
# ------------------------------------------------------------

# M/PSI4: build Psi4 w/o any RT deps or tests (***)
# -------------------------------------------------
{'recipe': 'psi4-multiout', 'build_channels': ['psi4/label/dev']},
#{'recipe': 'psi4-nola', 'build_channels': ['psi4/label/dev', 'psi4/label/agg', 'psi4'], 'dest_subchannel': 'nola'},  # qcdb

# M/RT-MP: build RT metapackage w/existing downstreams and new Psi4 (***)
#          upon any failure, step forward or back, adjusting source of downstream or Psi
# --------------------------------------------------------------------------------------
{'recipe': 'psi4-rt', 'build_channels': ['psi4/label/dev']},

# M/RT: if psi4-rt tests fail, build the downstream
# -------------------------------------------------
#{'recipe': 'dftd3'},
#{'recipe': 'gcp'},
#{'recipe': 'resp', 'build_channels': ['psi4/label/dev']},  # chnl: psi4
#{'recipe': 'snsmp2', 'build_channels': ['psi4/label/agg', 'psi4']},  # chnl: psi4
#{'recipe': 'v2rdm', 'build_channels': ['psi4/label/agg', 'psi4']},  # chnl: psi4

# M/DEV: build the deps package and test `psi4-path-advisor` (***)
# ----------------------------------------------------------------
{'recipe': 'psi4-dev', 'build_channels': ['psi4/label/dev', 'psi4']},
		]


if host == "psinet":
    candidates = [

#{'recipe': 'lawrap'},  # linux
#{'recipe': 'am7-mp'},
#{'recipe': 'am8-mp'},
#{'recipe': 'libint', 'build_channels': 'psi4', 'envvars': {'MAX_AM_ERI': '7'}},  # linux
#{'recipe': 'libint', 'build_channels': 'psi4', 'envvars': {'MAX_AM_ERI': '8'}},  # linux
#{'recipe': 'erd'},

# CBCY openblas --- dest_subchannel = 'nomkl'
#{'recipe': 'chemps2-multiout', 'dest_subchannel': 'nomkl'},
#{'recipe': 'libefp-multiout', 'build_channels': ['psi4'], 'dest_subchannel': 'nomkl'},  # deepdiff, pb11 from psi4
#{'recipe': 'psi4-multiout', 'build_channels': ['psi4/label/nomkl', 'psi4/label/dev', 'psi4'], 'dest_subchannel': 'nomkl'},


# starred (***) are nightly build

# L/MISC: order mostly doesn't matter
# -----------------------------------
#{'recipe': 'deepdiff', 'build_channels': ['conda-forge']},  # chnl: jsonpickle  # neededby: pylibefp, psi4, yesarch for constructor
#{'recipe': 'pytest-shutil', 'build_channels': ['defaults', 'conda-forge']},  # chnl: setuptools-git  # neededby: v2rdm  # Note: recipe fine but useless as c-b & pytest-shutil don't mix
#{'recipe': 'sphinx-psi-theme', 'build_channels': ['conda-forge']},  # chnl: cloud_sptheme  # neededby: psi4-docs
#{'recipe': 'openfermion', 'build_channels': ['defaults', 'bioconda']},  # chnl: pubchempy  # neededby: openfermionpsi4
#{'recipe': 'openfermionpsi4', 'build_channels': ['psi4/label/agg']},  # chnl: openfermion

# L/LT: bump in recipe any upstream versions Psi means to support and rebuild
#       upon any failure, adjust source of Psi & upstream
# ---------------------------------------------------------------------------
#{'recipe': 'ambit'},
#{'recipe': 'chemps2-multiout'},
#{'recipe': 'dkh'},
#{'recipe': 'libefp-multiout', 'build_channels': ['psi4']},  # chnl: deepdiff, pb11
#{'recipe': 'gau2grid-multiout'},
#{'recipe': 'gdma'},
#{'recipe': 'libint'},
#{'recipe': 'pcmsolver'},
#{'recipe': 'simint'},
#{'recipe': 'libxc'},

# L/CBCY: edit "ltrtver" & "<addon>" if anything in LT changed
# ------------------------------------------------------------

# L/PSI4: build Psi4 w/o any RT deps or tests (***)
# -------------------------------------------------
{'recipe': 'psi4-multiout', 'build_channels': ['psi4/label/dev']},
#{'recipe': 'psi4-multiout', 'build_channels': ['psi4/label/dev', 'psi4'], 'dest_subchannel': 'nola'},  # qcdb

# L/RT-MP: build RT metapackage w/existing downstreams and new Psi4 (***)
#          upon any failure, step forward or back, adjusting source of downstream or Psi
# -------------------------------------------------------------------------------------
{'recipe': 'psi4-rt', 'build_channels': ['psi4/label/dev']},

# L/RT: if psi4-rt tests fail, build the downstream
# -------------------------------------------------
#{'recipe': 'dftd3'},
#{'recipe': 'gcp'},
#{'recipe': 'gpudfcc', 'build_channels': ['psi4/label/dev']},  # chnl: psi4
#{'recipe': 'resp', 'build_channels': ['psi4/label/dev']},  # chnl: psi4
#{'recipe': 'snsmp2', 'build_channels': ['psi4/label/dev']},  # chnl: psi4
#{'recipe': 'v2rdm', 'build_channels': ['psi4/label/dev']},  # chnl: psi4

# L/DEV: build the deps package and test `psi4-path-advisor` (***)
# ----------------------------------------------------------------
{'recipe': 'psi4-dev', 'build_channels': ['psi4/label/dev']},

# L/DOCS: build the docs, feed, and doxygen targets (***)
# -------------------------------------------------------
{'recipe': 'psi4-docs', 'build_channels': ['psi4/label/dev', 'psi4', 'defaults', 'conda-forge', 'astropy'], 'cbextras': ['--prefix-length', '100']},  # chnl: codecov, sphinx* jupyter* astropy-helpers

# In future when `gcov` available, coverage can be added to psi4-docs recipe
#{'recipe': 'psi4-coverage', 'build_channels': ['psi4/label/dev', 'psi4', 'defaults', 'conda-forge', 'astropy'], 'cbextras': ['--prefix-length', '100']},  # chnl: cov*, docs*
        ]


for kw in candidates:
    time_string = datetime.datetime.now().strftime('%A, %d %B %Y %I:%M%p')
    print("""\n  <<<  {} starting: {}  >>>""".format(kw['recipe'], time_string))

    dst = kw.pop('dest_subchannel', dest_subchannel)
    ans = wrapped_conda_build(verbose=True,
                              keep=True,
                              dest_subchannel=dst,
                              cbcy=cbcy,
                              **kw)

    time_string = datetime.datetime.now().strftime('%A, %d %B %Y %I:%M%p')
    print("""\n  <<<  {} finishing: {}  >>>""".format(kw['recipe'], time_string))
    print("""\n  <<<  {} final disposition: {}  >>>\n""".format(kw['recipe'], ans))

#conda build v2rdm -c http://conda.anaconda.org/psi4/label/test -c http://conda.anaconda.org/psi4 --python 3.5
# CONDA_BLD_PATH=/scratch/psilocaluser/conda-builds/ /home/psilocaluser/bldmconda3/bin/conda build purge

#conda create -n tp4deps35 python=3.5 psi4-deps -c psi4/label/test -c psi4
#conda create -n tp4deps35 python=3.5 psi4-deps -c psi4

# >>> conda list | grep -e constr -e conda
# # packages in environment at /home/psilocaluser/toolchainconda:
# anaconda-client           1.6.14                   py36_0  
# conda                     4.5.2                    py36_0  
# conda-build               3.10.1                   py36_0  
# conda-env                 2.6.0                h36134e3_1  
# conda-verify              2.0.0            py36h98955d8_0  
# constructor               2.0.3                    py36_0  

# # packages in environment at /Users/github/toolchainconda:
# anaconda-client           1.6.14                   py36_0    defaults
# conda                     4.5.2                    py36_0    defaults
# conda-build               3.10.2                   py36_0    defaults
# conda-env                 2.6.0                         0    defaults
# conda-verify              2.0.0            py36he837df3_0    defaults
# libconda                  4.0.3                    py36_0    defaults



# constructor --platform linux-64 psi4-installer/
# constructor --platform osx-64 psi4-installer/
# scp -r psi4conda-1.1rc1-py* root@vergil.chemistry.gatech.edu:/var/www/html/download/
