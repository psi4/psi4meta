#!/home/psilocaluser/bldmconda3/bin/python

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
    cbcy = None
    #dest_subchannel = 'agg'
    #psi4_dest_subchannel = 'agg'
    #cbcy = '/home/psilocaluser/gits/psi4meta/conda-recipes/conda_build_config.yaml'
    recipe_box = '/home/psilocaluser/gits/psi4meta/conda-recipes'
    lenv = {
        'CPU_COUNT': '8',
        'CONDA_BLD_PATH': '/scratch/psilocaluser/conda-builds',
        'PATH': '/home/psilocaluser/bldmconda3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
        #'PATH': '/home/psilocaluser/toolchainconda/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
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
                        envvars=None, cbcy=None):

    pyxx = _form_python_command(python)
    chnls = _form_channel_command(build_channels)
    if envvars:
        lenv.update(envvars)

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
    if cbcy:
        command.append('--variant-config-files')
        command.append(cbcy)
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
#{'recipe': 'libint', 'build_channels': 'psi4', 'envvars': {'MAX_AM_ERI': '7'}},  # linux
#{'recipe': 'libint', 'build_channels': 'psi4', 'envvars': {'MAX_AM_ERI': '8'}},  # linux
#{'recipe': 'pcmsolver', 'python': '2.7', 'build_channels': 'psi4'},  # linux
#{'recipe': 'pcmsolver', 'python': '3.5', 'build_channels': 'psi4'},  # linux
#{'recipe': 'pcmsolver', 'python': '3.6', 'build_channels': 'psi4'},  # linux
#{'recipe': 'simint'},
#{'recipe': 'libxc'},  # linux

#{'recipe': 'dftd3'},
#{'recipe': 'gcp'},
#{'recipe': 'v2rdm', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']},  # linux
#{'recipe': 'v2rdm', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4']},  # linux
#{'recipe': 'v2rdm', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']},  # linux
{'recipe': 'snsmp2', 'python': '2.7'},
{'recipe': 'snsmp2', 'python': '3.5'},
{'recipe': 'snsmp2', 'python': '3.6'},

#{'recipe': 'psi4-rt', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-rt', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-rt', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-lt-mp', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-lt-mp', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-lt-mp', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-dev', 'python': '2.7', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-dev', 'python': '3.5', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
#{'recipe': 'psi4-dev', 'python': '3.6', 'build_channels': ['psi4/label/dev', 'psi4']},  # linuxmkl
                 ]

if host == "psinet":
    for py in ['2.7', '3.5', '3.6']:
        docs = '1' if py == '3.5' else '0'
        #continue  # commented allows all psi4-core builds / uncommented suppresses
        candidates.append({'recipe': 'psi4-core',
                           'python': py,
                           'build_channels': ['psi4/label/dev', 'psi4', 'intel', 'defaults', 'conda-forge', 'astropy'],
                           #'build_channels': ['psi4/label/agg', 'defaults'] })
                           'envvars': {'PSI_BUILD_DOCS': docs}})
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
    ans = wrapped_conda_build(verbose=True, keep=False, dest_subchannel=dst, cbcy=cbcy, **kw)
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


# constructor --platform linux-64 psi4-installer/
# constructor --platform osx-64 psi4-installer/
# scp -r psi4conda-1.1rc1-py* root@vergil.chemistry.gatech.edu:/var/www/html/download/
