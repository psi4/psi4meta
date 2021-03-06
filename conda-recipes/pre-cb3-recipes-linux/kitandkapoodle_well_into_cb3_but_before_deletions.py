#!/home/psilocaluser/toolchainconda/bin/python

#!/home/psilocaluser/bldmconda3/bin/python
#!/Users/github/bldmconda3/bin/python

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
    #dest_subchannel = 'main'
    #psi4_dest_subchannel = 'dev'
    #cbcy = None
    #dest_subchannel = 'nomkl'
    #dest_subchannel = 'agg'
    #psi4_dest_subchannel = 'agg'
    dest_subchannel = 'dev'
    psi4_dest_subchannel = 'dev'
    recipe_box = '/home/psilocaluser/gits/psi4meta/conda-recipes'
    cbcy = recipe_box + '/conda_build_config.yaml'
    lenv = {
        #'CPU_COUNT': '8',
        'CPU_COUNT': '12',
        'CONDA_BLD_PATH': '/scratch/psilocaluser/conda-builds',
        #'PATH': '/home/psilocaluser/bldmconda3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
        'PATH': '/home/psilocaluser/toolchainconda/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
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
    print('build_products', build_products)
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
#{'recipe': 'sphinx-psi-theme', 'python': '2.7', 'build_channels': ['conda-forge']},  # macmkl
#{'recipe': 'sphinx-psi-theme', 'python': '3.5', 'build_channels': ['conda-forge']},  # macmkl
#{'recipe': 'sphinx-psi-theme', 'python': '3.6', 'build_channels': ['conda-forge']},  # macmkl
#{'recipe': 'lawrap'},  # mac
#{'recipe': 'gcc-5-mp', 'build_channels': 'psi4'},  # mac
#{'recipe': 'gnu-mp'},  # mac
#{'recipe': 'chemps2', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'sse41', 'PSI_BUILD_CCFAM': 'gnu'}},  # mac
#{'recipe': 'chemps2', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'avx2', 'PSI_BUILD_CCFAM': 'gnu'}},  # mac
#{'recipe': 'chemps2', 'build_channels': ['psi4'], 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # macmkl
#{'recipe': 'chemps2', 'build_channels': ['psi4'], 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # macmkl
#{'recipe': 'pychemps2', 'python': '2.7', 'build_channels': ['psi4']},  # macmkl
#{'recipe': 'pychemps2', 'python': '3.5', 'build_channels': ['psi4']},  # macmkl
#{'recipe': 'pychemps2', 'python': '3.6', 'build_channels': ['psi4']},  # macmkl
#{'recipe': 'dkh', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # mac
#{'recipe': 'dkh', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # mac
#{'recipe': 'libefp', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # macmkl doesn't need b_c:psi4
#{'recipe': 'libefp', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # macmkl
#{'recipe': 'erd', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # mac
#{'recipe': 'erd', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # mac
#{'recipe': 'gdma', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # mac
#{'recipe': 'gdma', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # mac
#{'recipe': 'am7-mp'},  # mac
#{'recipe': 'am8-mp'},  # mac
#{'recipe': 'libint'},  # toggle recipes for AM feature
#{'recipe': 'libint', 'envvars': {'MAX_AM_ERI': '6', 'PSI_BUILD_ISA': 'sse41'}},
#{'recipe': 'pcmsolver', 'python': '2.7', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # mac doesn't need b_c:psi4
#{'recipe': 'pcmsolver', 'python': '2.7', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # mac
#{'recipe': 'pcmsolver', 'python': '3.5', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # mac
#{'recipe': 'pcmsolver', 'python': '3.5', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # mac
#{'recipe': 'pcmsolver', 'python': '3.6', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # mac
#{'recipe': 'pcmsolver', 'python': '3.6', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # mac
#{'recipe': 'simint', 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # mac
#{'recipe': 'simint', 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # mac
#{'recipe': 'sse41-mp'},  # mac
#{'recipe': 'libxc', 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # mac
#{'recipe': 'libxc', 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # mac

#{'recipe': 'dftd3'},  # not yet built on mac
#{'recipe': 'gcp'},  # not yet built on mac
#{'recipe': 'v2rdm', 'python': 'x.x', 'build_channels': ['psi4'], 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # mac 1.1 pinned
#{'recipe': 'v2rdm', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4'], 'envvars': {'PSI_BUILD_ISA': 'sse41', 'PSI_BUILD_CCFAM': 'gnu'}},  # mac
#{'recipe': 'v2rdm', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4'], 'envvars': {'PSI_BUILD_ISA': 'avx2', 'PSI_BUILD_CCFAM': 'gnu'}},  # mac
#{'recipe': 'v2rdm', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4'], 'envvars': {'PSI_BUILD_ISA': 'sse41', 'PSI_BUILD_CCFAM': 'default'}},  # mac
#{'recipe': 'v2rdm', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4'], 'envvars': {'PSI_BUILD_ISA': 'avx2', 'PSI_BUILD_CCFAM': 'default'}},  # mac
#{'recipe': 'v2rdm', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4'], 'envvars': {'PSI_BUILD_ISA': 'sse41', 'PSI_BUILD_CCFAM': 'default'}},  # mac
#{'recipe': 'v2rdm', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4'], 'envvars': {'PSI_BUILD_ISA': 'avx2', 'PSI_BUILD_CCFAM': 'default'}},  # mac
#{'recipe': 'v2rdm', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4'], 'envvars': {'PSI_BUILD_ISA': 'sse41', 'PSI_BUILD_CCFAM': 'default'}},  # mac
#{'recipe': 'v2rdm', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4'], 'envvars': {'PSI_BUILD_ISA': 'avx2', 'PSI_BUILD_CCFAM': 'default'}},  # mac

#{'recipe': 'psi4-rt', 'python': '2.7', 'build_channels': 'psi4'},
#{'recipe': 'psi4-rt', 'python': '3.5', 'build_channels': 'psi4'},
#{'recipe': 'psi4-rt', 'python': '3.6', 'build_channels': 'psi4'},
#{'recipe': 'psi4-lt-mp', 'python': '2.7', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # macmkl
#{'recipe': 'psi4-lt-mp', 'python': '2.7', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # macmkl
#{'recipe': 'psi4-lt-mp', 'python': '3.5', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # macmkl
#{'recipe': 'psi4-lt-mp', 'python': '3.5', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # macmkl
#{'recipe': 'psi4-lt-mp', 'python': '3.6', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'sse41'}},  # macmkl
#{'recipe': 'psi4-lt-mp', 'python': '3.6', 'build_channels': 'psi4', 'envvars': {'PSI_BUILD_ISA': 'avx2'}},  # macmkl
#{'recipe': 'psi4-dev', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']},  # macmkl  needs fno-openmp removed
#{'recipe': 'psi4-dev', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4']},  # macmkl  "
#{'recipe': 'psi4-dev', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']},  # macmkl  "
#{'recipe': 'p4test', 'python': '3.6'}, #, 'build_channels': ['psi4']},  # bldstr 0-4
#{'recipe': 'p4test', 'python': '3.6' , 'build_channels': ['psi4/label/oldmac', 'psi4']},
#{'recipe': 'p4test', 'python': '3.5' , 'build_channels': ['intel']}, #['psi4/label/oldmac', 'psi4']},  # bldstr 6, 7, 9
#{'recipe': 'p4test', 'python': '3.5' , 'build_channels': ['intel', 'psi4']}, #['psi4/label/oldmac', 'psi4']},  # bldstr 8
#{'recipe': 'p4test', 'python': '3.6' , 'build_channels': ['psi4', 'defaults', 'intel']}, #['psi4/label/oldmac', 'psi4']},  # bldstr 10, 11
#{'recipe': 'p4test', 'python': '3.6' , 'envvars': {'PSI_BUILD_ISA': 'sse41'}, 'build_channels': ['psi4', 'defaults', 'intel']},  # bldstr 12
#{'recipe': 'p4test', 'python': '3.6' , 'envvars': {'PSI_BUILD_ISA': 'sse41'}, 'build_channels': ['psi4', 'defaults', 'intel']},  # bldstr 13
		]

if host == "psinet":
    candidates = [
#{'recipe': 'ci-psi4', 'python': '2.7'},  # linux
#{'recipe': 'ci-psi4', 'python': '3.5'},  # linux
#{'recipe': 'ci-psi4', 'python': '3.6'},  # linux
#{'recipe': 'ci-psi4-lt', 'python': '2.7'},  # linux
#{'recipe': 'ci-psi4-lt', 'python': '3.5'},  # linux
#{'recipe': 'ci-psi4-lt', 'python': '3.6'},  # linux
#{'recipe': 'sphinx-psi-theme', 'python': '2.7', 'build_channels': ['conda-forge']},  # linuxmkl
#{'recipe': 'sphinx-psi-theme', 'python': '3.5', 'build_channels': ['conda-forge']},  # linuxmkl
#{'recipe': 'sphinx-psi-theme', 'python': '3.6', 'build_channels': ['conda-forge']},  # linuxmkl
#{'recipe': 'hungarian', 'python': '2.7'},
#{'recipe': 'hungarian', 'python': '3.5'},
#{'recipe': 'hungarian', 'python': '3.6'},

#{'recipe': 'chemps2', 'build_channels': ['psi4', 'intel']},  # linuxmkl
#{'recipe': 'lawrap'},  # linux
#{'recipe': 'pychemps2', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'pychemps2', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'pychemps2', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'dkh', 'build_channels': 'psi4'},  # linux
#{'recipe': 'libefp', 'build_channels': 'psi4'},  # linuxmkl
###{'recipe': 'pylibefp', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4', 'conda-forge']},  # linuxmkl
###{'recipe': 'pylibefp', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4', 'conda-forge']},  # linuxmkl
#{'recipe': 'erd', 'build_channels': 'psi4'},  # linux
#{'recipe': 'gdma', 'build_channels': 'psi4'},  # linux
#{'recipe': 'am7-mp'},
#{'recipe': 'am8-mp'},
#{'recipe': 'libint', 'envvars': {'MAX_AM_ERI': '6'}},  # linux
#{'recipe': 'libint'},  # linux
#{'recipe': 'libint', 'build_channels': 'psi4', 'envvars': {'MAX_AM_ERI': '7'}},  # linux
#{'recipe': 'libint', 'build_channels': 'psi4', 'envvars': {'MAX_AM_ERI': '8'}},  # linux
#{'recipe': 'pcmsolver', 'python': '2.7', 'build_channels': 'psi4'},  # linux
#{'recipe': 'pcmsolver', 'python': '3.5', 'build_channels': 'psi4'},  # linux
#{'recipe': 'pcmsolver', 'python': '3.6', 'build_channels': 'psi4'},  # linux
#{'recipe': 'simint'},
#{'recipe': 'libxc'},  # linux
#{'recipe': 'gau2grid', 'python': '3.6'},  # linuxmkl
#{'recipe': 'dftd3'},
#{'recipe': 'gcp'},
#{'recipe': 'v2rdm', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']},  # linux
#{'recipe': 'v2rdm', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4']},  # linux
#{'recipe': 'v2rdm', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']},  # linux
#{'recipe': 'snsmp2', 'python': '2.7'},
#{'recipe': 'snsmp2', 'python': '3.5'},
#{'recipe': 'snsmp2', 'python': '3.6'},

#{'recipe': 'psi4-rt', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-rt', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-rt', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-lt-mp', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-lt-mp', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-lt-mp', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-dev', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-dev', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-dev', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl


# CBCY openblas --- dest_subchannel = 'nomkl'
#{'recipe': 'chemps2-multiout'},  # cb3
#{'recipe': 'libefp-multiout', 'build_channels': ['psi4']},  # deepdiff, pb11 from psi4

# Unplaced
#{'recipe': 'gau2grid-multiout'},  # cb3
#{'recipe': 'gdma'},  # cb3
#{'recipe': 'dkh'},  # cb3
#{'recipe': 'libxc'},  # cb3
#{'recipe': 'erd'},

# LT: bump in recipe any upstream versions Psi means to support and rebuild
#     upon any failure, adjust source of Psi & upstream
# -------------------------------------------------------------------------
#{'recipe': 'pcmsolver'},
#{'recipe': 'chemps2-multiout'},
#{'recipe': 'libint'},
#{'recipe': 'libefp-multiout', 'build_channels': ['psi4']},  # deepdiff, pb11 from psi4

# CBCY: edit "ltrtver" & "<addon>" if anything in LT changed
# ----------------------------------------------------------

# PSI4: build Psi4 w/o any RT deps or tests
# -----------------------------------------
#{'recipe': 'psi4-multiout', 'build_channels': ['psi4/label/dev', 'psi4']},

# RT-MP: build RT metapackage w/existing downstreams and new Psi4
#        upon any failure, step forward or back, adjusting source of downstream or Psi
# ---------------------------------------------------------------------------------
#{'recipe': 'psi4-rt', 'build_channels': ['psi4/label/dev', 'psi4']},

# RT: if psi4-rt tests fail, build the downstream
# -----------------------------------------------
#{'recipe': 'dftd3'},
#{'recipe': 'gcp'},
#{'recipe': 'snsmp2', 'build_channels': ['psi4/label/dev', 'psi4']},  # psi4, deepdiff from psi4
#{'recipe': 'v2rdm', 'build_channels': ['psi4/label/dev', 'psi4']},  # psi4, deepdiff from psi4

# DEV: build the deps package and test `psi4-path-advisor`
# --------------------------------------------------------
#{'recipe': 'psi4-dev', 'build_channels': ['psi4/label/dev', 'psi4']},

# DOCS: build the docs, feed, and doxygen targets
# -----------------------------------------------
{'recipe': 'psi4-docs', 'build_channels': ['psi4/label/agg', 'psi4', 'defaults', 'conda-forge', 'astropy'], 'cbextras': ['--prefix-length', '100']},

                 ]

if host == "psinet":
    #for py in ['2.7', '3.5', '3.6']:
    #for py in ['3.6']:
    #    docs = '1' if py == '3.5' else '0'
    #if True:
    if False:
        #continue  # commented allows all psi4-core builds / uncommented suppresses
        #candidates.append({'recipe': 'psi4-core',
        #candidates.append({'recipe': 'nu-psi4-core',
        candidates.append({'recipe': 'psi4-multiout',
                           #'python': py,
                           #'build_channels': ['psi4/label/dev', 'psi4', 'intel', 'defaults', 'conda-forge', 'astropy'],
                           'build_channels': ['psi4/label/agg', 'psi4', 'defaults'] })  # intel for icc_rt
                           #'build_channels': ['psi4/label/agg', 'defaults', 'intel'] })  # intel for icc_rt
                           #'envvars': {'PSI_BUILD_DOCS': docs}})
if host == "macpsinet":
    for py in ['2.7', '3.5', '3.6']:
        for isa in ['sse41', 'avx2']:
            for ccfam in ['gnu', 'default']:
                if (ccfam == 'gnu') and (py != '3.5'):
                    continue
                #continue  # commented allows all psi4-core builds / uncommented suppresses
                candidates.append({'recipe': 'psi4-core',
                                   'python': py,
                                   'build_channels': ['psi4/label/dev', 'psi4', 'defaults', 'intel'],
                                   'envvars': {'PSI_BUILD_ISA': isa,
                                               'PSI_BUILD_CCFAM': ccfam}})
# psi4/label/dev above catches addon updates not suitable for 1.1 release (i.e., v2rdm)


for kw in candidates:
    time_string = datetime.datetime.now().strftime('%A, %d %B %Y %I:%M%p')
    print("""\n  <<<  {} starting: {}  >>>""".format(kw['recipe'], time_string))

    dst = psi4_dest_subchannel if kw['recipe'] == 'psi4-core' else dest_subchannel
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
# 18 Jul 2017 - below ok but really long so back to 2.1.8
# conda-build               3.0.6                    py36_0    defaults

# 26 Mar 2018
# # packages in environment at /home/psilocaluser/toolchainconda:
# anaconda-client           1.6.14                   py36_0  
# conda                     4.5.0                    py36_0  
# conda-build               3.7.2                    py36_0  
# conda-env                 2.6.0                h36134e3_1  
# conda-verify              2.0.0            py36h98955d8_0  
# ipython_genutils          0.2.0            py36hb52b0d5_0  
# libgcc-ng                 7.2.0                hdf63c60_3  
# libstdcxx-ng              7.2.0                hdf63c60_3  
# python                    3.6.4                hc3d631a_3  
# python-dateutil           2.6.1            py36h88d3b88_1  

# >>> conda list | grep -e conda -e python -e ng
# # packages in environment at /home/psilocaluser/toolchainconda:
# anaconda-client           1.6.14                   py36_0  
# conda                     4.3.30           py36h5d9f9f4_0  
# conda-build               3.8.0                    py36_0  
# conda-env                 2.6.0                h36134e3_1  
# conda-verify              2.0.0            py36h98955d8_0  
# ipython_genutils          0.2.0            py36hb52b0d5_0  
# libgcc-ng                 7.2.0                hdf63c60_3  
# libstdcxx-ng              7.2.0                hdf63c60_3  
# python                    3.6.0                         0  
# python-dateutil           2.7.2                    py36_0  

# >>> conda list | grep -e constr -e conda
# # packages in environment at /home/psilocaluser/toolchainconda:
# anaconda-client           1.6.14                   py36_0  
# conda                     4.5.2                    py36_0  
# conda-build               3.10.1                   py36_0  
# conda-env                 2.6.0                h36134e3_1  
# conda-verify              2.0.0            py36h98955d8_0  
# constructor               2.0.3                    py36_0  



# constructor --platform linux-64 psi4-installer/
# constructor --platform osx-64 psi4-installer/
# scp -r psi4conda-1.1rc1-py* root@vergil.chemistry.gatech.edu:/var/www/html/download/
