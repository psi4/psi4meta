#!/opt/anaconda1anaconda2anaconda3/bin/python

from __future__ import print_function
import os
import sys
import argparse
from argparse import RawTextHelpFormatter

parser = argparse.ArgumentParser(description="Build and Run path advisor for Psi4",
                                 formatter_class=RawTextHelpFormatter)

parser.add_argument('--psi4-compile', action='store_true', help="""\
(Command Default) Generates a minimal CMake command for building Psi4 against
    this psi4-dev conda metapackage.
>>> git clone https://github.com/psi4/psi4.git
>>> cd {top-level-psi4-dir}
>>> conda create -n p4dev python={3.6} psi4-dev -c psi4[/label/dev]
>>> conda activate p4dev
>>> psi4-path-advisor
# execute or adapt `cmake` commands above; DepsCache handles python & addons;
#   DepsMKLCache handles math; further psi4-path-advisor options handle compilers.
>>> cd objdir && make -j`getconf _NPROCESSORS_ONLN`
>>> make install""")

parser.add_argument('--disable-addons', action='store_true',
                    help="""Disengage building against the psi4-dev-provided _optional_ link-time Add-Ons like CheMPS2.""")

parser.add_argument('--disable-mkl', action='store_false', dest='mkl',
                    help="""Disengage building against the psi4-dev-provided MKL libraries (`libmkl_rt`).""")

if sys.platform.startswith('linux'):
    group = parser.add_mutually_exclusive_group(required=False)
    group.add_argument('--intel', action='store_true',
                        help="""Engage self-provided icc/icpc/ifort compilers backed by conda's psi4-dev-provided gcc/g++.""")
    group.add_argument('--intel-multiarch', action='store_true',
                        help="""Engage self-provided icc/icpc/ifort compilers backed by conda's psi4-dev-provided gcc/g++ PLUS compile for multiple architectures (useful for cluster deployments).""")
    group.add_argument('--gcc', action='store_true',
                        help="""Engage conda's psi4-dev-provided gcc/g++/gfortran compilers.""")

elif sys.platform == 'darwin':
    parser.add_argument('--clang', action='store_true',
                        help="""Engage conda's psi4-dev-provided clang/clang++/gfortran compilers. !Change! this arg formerly invoked XCode AppleClang.""")
    #                    help="""Engage system-provided clang/clang++ compilers and psi4-dev-provided gfortran.""")
    #parser.add_argument('--gcc', action='store_true',
    #                    help="""Engage psi4-dev-provided gcc/g++/gfortran compilers.""")

# duplicates from `bin/psi4`
psi4 = os.path.abspath(os.path.dirname(__file__)) + os.path.sep + 'psi4'
psi4alongside = os.path.isfile(psi4) and os.access(psi4, os.X_OK)

if psi4alongside:
    parser.add_argument("--psiapi-path", action='store_true',
                        help="""(Duplicate from `psi4`) Generates a bash command to source correct Python for `python -c "import psi4"`""")
    
parser.add_argument('--plugin-compile', action='store_true', help="""\
(Duplicate from `psi4`) Generates a CMake command for building a plugin against this Psi4 installation.
>>> cd <plugin_directory>
>>> `psi4 --plugin-compile`
>>> make
>>> psi4""")

args = parser.parse_args()


if psi4alongside:
    from subprocess import call

    if args.psiapi_path:
        call([psi4, '--psiapi-path'])
        sys.exit(0)

    if args.plugin_compile:
        call([psi4, '--plugin-compile'])
        sys.exit(0)

else:
    if args.plugin_compile:
        print("""Install "psi4" via `conda install psi4 -c psi4[/label/dev]`, then reissue command.""")



#advice = {
#    'cmake':  '/opt/anaconda1anaconda2anaconda3/bin/cmake \\',
#    'here':   '    -H. \\',
#    'deps':   '    -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsCache.cmake \\',
#    'nooptl': '    -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsDisableCache.cmake \\',
#    'Lintel': '    -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsIntelCache.cmake \\',
#    'Lgnu':   '    -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsGNUCache.cmake \\',
#    'Mclang': '    -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsAppleClangCache.cmake \\',
#    'Mgnu':   '    -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsGNUCache.cmake \\',
#    'objdir': '    -Bobjdir',
#}

recc = ['/opt/anaconda1anaconda2anaconda3/bin/cmake',
        '-H.',
        '-C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsCache.cmake',
        '-Bobjdir']

if args.disable_addons:
    recc.insert(-1, '-C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsDisableCache.cmake')

if args.mkl:
    recc.insert(-1, '-C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsMKLCache.cmake')

if sys.platform.startswith('linux'):
    if args.intel:
        recc.insert(-1, '-C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsIntelCache.cmake')
    if args.intel_multiarch:
        recc.insert(-1, '-C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsIntelMultiarchCache.cmake')
    if args.gcc:
        recc.insert(-1, '-C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsGNUCache.cmake')

if sys.platform == 'darwin':
    if args.clang:
        recc.insert(-1, '-C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsClangCache.cmake')
    #    recc.insert(-1, '-C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsAppleClangCache.cmake')
    #if args.gcc:
    #    recc.insert(-1, '-C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsGNUCache.cmake')

srecc = """    """.join(recc)
print(srecc)
