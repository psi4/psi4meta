
def main_help():
    """Returns minimal `cmake` command to build Psi4 against a psi4-deps conda package."""

    text = r"""
/opt/anaconda1anaconda2anaconda3/bin/cmake \
    -H. \
    -C/opt/anaconda1anaconda2anaconda3/share/cmake/psi4/psi4DepsCache.cmake \
    -Bobjdir

# Overview
# -------
# >>> cd {top-level-psi4-dir}
# >>> conda create -n p4deps python=3.5 psi4-deps -c psi4
# >>> source activate p4deps
# >>> help-psi4-deps
# # use or adapt `cmake` commands above; DepsCache handles python & addons; Note compiler snippets below
# >>> cd objdir  && make -j`getconf _NPROCESSORS_ONLN`
# >>> make install

# Mac Clang
# ---------
#    -DCMAKE_C_COMPILER=clang \
#    -DCMAKE_CXX_COMPILER=clang++ \
#    -DCMAKE_CXX_FLAGS="-stdlib=libc++" \

# Mac GCC
# -------
# Conda packages on the psi4 channel osx-64 arch are built with clang/libc++,
# not gcc/libstdc++. They are therefore unsuited for linking with a
# gcc-built Psi4, though the simplest ones (e.g., C-only libint) may work.

# Mac or Linux gfortran (independent of C/CXX compiler family)
# ---------------------
#    -DCMAKE_Fortran_COMPILER="/opt/anaconda1anaconda2anaconda3/bin/gfortran" \

# Linux GCC
# ---------
#    -DCMAKE_C_COMPILER="/opt/anaconda1anaconda2anaconda3/bin/gcc" \
#    -DCMAKE_CXX_COMPILER="/opt/anaconda1anaconda2anaconda3/bin/g++" \

# Linux Intel
# -----------
#    -DCMAKE_C_COMPILER=icc \
#    -DCMAKE_C_FLAGS="-gcc-name=/opt/anaconda1anaconda2anaconda3/bin/gcc" \
#    -DCMAKE_CXX_COMPILER=icpc \
#    -DCMAKE_CXX_FLAGS="-gcc-name=/opt/anaconda1anaconda2anaconda3/bin/gcc -gxx-name=/opt/anaconda1anaconda2anaconda3/bin/g++" \
#    -DCMAKE_Fortran_COMPILER=ifort \
#    -DCMAKE_Fortran_FLAGS="-gcc-name=/opt/anaconda1anaconda2anaconda3/bin/gcc -gxx-name=/opt/anaconda1anaconda2anaconda3/bin/g++" \
"""

    return text
