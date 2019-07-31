import tarfile

# >>> cp -pR ../libint-1.2.1-hb4a4fd4_5.tar.bz2 .
# >>> bunzip2 libint-1.2.1-hb4a4fd4_5.tar.bz2
# increment build number on file
# -rw-r--r--. 1 psilocaluser psilocaluser 863608320 Feb 13 05:43 libint-1.2.1-hb4a4fd4_6.tar
# -rw-rw-r--. 1 psilocaluser psilocaluser 1989      Mar  7 16:25 include/libderiv/libderiv.h

tarf = 'libint-1.2.1-hb4a4fd4_6.tar'  # linux
tarf = 'libint-1.2.1-h1989688_2.tar'  # osx

def reset(tarinfo):
    # I don't know if it's the OS or the era in which I made the packages that determines these differences

    # linux
    tarinfo.uid = tarinfo.gid = 1000
    tarinfo.uname = tarinfo.gname = "1000"

    # osx
    tarinfo.uid = 503
    tarinfo.gid = 20
    tarinfo.uname = "github"
    tarinfo.gname = "staff"

    return tarinfo

tar = tarfile.open(tarf, mode='a:')
print('Before:')
tar.list()
tar.add('include/libderiv/libderiv.h', filter=reset)
print('After:')
tar.list()
tar.close()

# may need to :set bt=acwrite
# vi and add file to info/files and info/paths.json
# vi and edit build str in info/index.json and info/recipe/meta*

# >>> bzip2 libint-1.2.1-hb4a4fd4_6.tar

# >>> anaconda upload /scratch/psilocaluser/conda-builds/linux-64/test2/libint-1.2.1-hb4a4fd4_6.tar.bz2 --label test
# >>> anaconda upload /scratch/psilocaluser/conda-builds/osx-64/libint-1.2.1-h1989688_2.tar.bz2 --label test
