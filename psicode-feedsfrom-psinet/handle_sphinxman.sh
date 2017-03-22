#!/bin/sh  
DOCSTAR=~/machinations/cb-sphinxman.tar.gz
FEEDSTAR=~/machinations/cb-feed.tar.gz
DOXYSTAR=~/machinations/cb-doxyman.tar.gz
# */15 * * * * bash ~/machinations/handle_sphinxman.sh >>~/machinations/ct.log 2>&1

echo ""
echo "handle_sphinxman.sh: episode" `date`

echo "handle_sphinxman.sh: starting on $DOCSTAR"
if [ -f "$DOCSTAR" ]; then

    echo "handle_sphinxman.sh: shifting aside existing docs"
    rm -rf ~/html/psi4manual/master-but-one/
    mv ~/html/psi4manual/master/ ~/html/psi4manual/master-but-one/

    echo "handle_sphinxman.sh: unpacking new docs"
    tar -zxf $DOCSTAR -C ~/html/psi4manual/

    echo "handle_sphinxman.sh: removing tarball"
    rm $DOCSTAR
fi

echo "handle_sphinxman.sh: starting on $FEEDSTAR"
if [ -f "$FEEDSTAR" ]; then

    echo "handle_sphinxman.sh: shifting aside existing feed"
    rm -rf ~/html/psi4manual/feed-but-one/
    mv ~/html/psi4manual/feed/ ~/html/psi4manual/feed-but-one/

    echo "handle_sphinxman.sh: unpacking new feed"
    tar -zxf $FEEDSTAR -C ~/html/psi4manual/

    echo "handle_sphinxman.sh: removing tarball"
    rm $FEEDSTAR
fi

echo "handle_sphinxman.sh: starting on $DOXYSTAR"
if [ -f "$DOXYSTAR" ]; then

    echo "handle_sphinxman.sh: shifting aside existing doxy"
    rm -rf ~/html/psi4manual/doxymaster-but-one/
    mv ~/html/psi4manual/doxymaster/ ~/html/psi4manual/doxymaster-but-one/

    echo "handle_sphinxman.sh: unpacking new doxy"
    tar -zxf $DOXYSTAR -C ~/html/psi4manual/

    echo "handle_sphinxman.sh: removing tarball"
    rm $DOXYSTAR
fi

echo "handle_sphinxman.sh: completing"

