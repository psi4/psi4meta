#!/bin/sh  
DOCSTAR=~/machinations/cb-sphinxman.tar.gz
FEEDSTAR=~/machinations/cb-feed.tar.gz
# */15 * * * * bash ~/machinations/handle_sphinxman.sh >~/machinations/ct.log 2>&1

echo "handle_sphinxman.sh: starting on $DOCSTAR"
if [ -f "$DOCSTAR" ]; then

    echo "handle_sphinxman.sh: shifting aside existing docs"
    rm -rf ~/html/psi4manual/master-but-one/
    mv ~/html/psi4manual/master/ ~/html/psi4manual/master-but-one/

    echo "handle_sphinxman.sh: unpacking new docs"
    tar -zxvf $DOCSTAR -C ~/html/psi4manual/

    echo "handle_sphinxman.sh: removing tarball"
    rm $DOCSTAR
fi

echo "handle_sphinxman.sh: starting on $FEEDSTAR"
if [ -f "$FEEDSTAR" ]; then

    echo "handle_sphinxman.sh: shifting aside existing feed"
    rm -rf ~/html/psi4manual/feed-but-one/
    mv ~/html/psi4manual/feed/ ~/html/psi4manual/feed-but-one/

    echo "handle_sphinxman.sh: unpacking new feed"
    tar -zxvf $FEEDSTAR -C ~/html/psi4manual/

    echo "handle_sphinxman.sh: removing tarball"
    rm $FEEDSTAR
fi
echo "handle_sphinxman.sh: completing"


