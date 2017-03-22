#!/bin/sh  

cd /theoryfs2/ds/cdsgroup/psi4-compile/psi4meta/psicode_dropbox/

# */7 * * * * bash /theoryfs2/ds/cdsgroup/psi4-compile/psi4meta/psinet-nightly/handle_sphinxman.sh >/theoryfs2/ds/cdsgroup/psi4-compile/psi4meta/psinet-nightly/psicode-dropbox.log 2>&1

# This continually looks in a folder for tarball byproducts from the Linux py35 conda build.
# Uses double scp because single often fails, even command-line
# The godaddy site keeps changing identities so circumventing check

echo ""
echo "psinet handle_sphinxman.sh: episode" `date`

if [[ -f "cb-sphinxman.tar.gz" ]]; then
    echo "initial upload sphinxman"
    scp -rv -o 'StrictHostKeyChecking no' cb-sphinxman.tar.gz psicode@www.psicode.org:~/machinations/cb-sphinxman.tar.gz && rm -f cb-sphinxman.tar.gz
    while [ $? -ne 0 ]; do
        sleep 6
        echo "trying to upload sphinxman"
        scp -rv -o 'StrictHostKeyChecking no' cb-sphinxman.tar.gz psicode@www.psicode.org:~/machinations/cb-sphinxman.tar.gz && rm -f cb-sphinxman.tar.gz
    done
fi

if [[ -f "cb-feed.tar.gz" ]]; then
    echo "initial upload ghfeed"
    scp -rv -o 'StrictHostKeyChecking no' cb-feed.tar.gz psicode@www.psicode.org:~/machinations/cb-feed.tar.gz && rm -f cb-feed.tar.gz
    while [ $? -ne 0 ]; do
        sleep 6
        echo "trying to upload ghfeed"
        scp -rv -o 'StrictHostKeyChecking no' cb-feed.tar.gz psicode@www.psicode.org:~/machinations/cb-feed.tar.gz && rm -f cb-feed.tar.gz
    done
fi

if [[ -f "cb-doxyman.tar.gz" ]]; then
    echo "initial upload doxyman"
    scp -rv -o 'StrictHostKeyChecking no' cb-doxyman.tar.gz psicode@www.psicode.org:~/machinations/cb-doxyman.tar.gz && rm -f cb-doxyman.tar.gz
    while [ $? -ne 0 ]; do
        sleep 6
        echo "trying to upload doxyman"
        scp -rv -o 'StrictHostKeyChecking no' cb-doxyman.tar.gz psicode@www.psicode.org:~/machinations/cb-doxyman.tar.gz && rm -f cb-doxyman.tar.gz
    done
fi

