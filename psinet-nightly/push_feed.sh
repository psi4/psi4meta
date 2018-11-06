#!/bin/sh  

#
# this script is to be run from a crontab and will periodically push
# text files over to psicode.  In particular, it will push a feed of
# recent articles citing the Psi4 paper, as found in 
# psi4meta/recent-citing-articles,
# and a feed of recent github commits, as found in
# psi4meta/github-feed
#
# C. David Sherrill, 1 February 2018
# based on a similar script, handle_sphinxman.sh, by Lori Burns
# 


# example crontab, run every hour at 52 after the hour: 
# 52 * * * * bash /home/psilocaluser/gits/psi4meta/psinet-nightly/push_feed.sh >>/home/psilocaluser/gits/psi4meta/psinet-nightly/push_feed.log 2>&1

# Uses double scp because single often fails, even command-line
# The godaddy site keeps changing identities so circumventing check

echo ""
echo "psinet push_feed.sh: episode" `date`

cd /home/psilocaluser/gits/psi4meta/recent-citing-articles/

if [[ -f "most_recent_article.txt" ]]; then
    echo "first try to upload most_recent_article.txt"
    scp -rv -o 'StrictHostKeyChecking no' most_recent_article.txt psicode@www.psicode.org:~/html/feed/most_recent_article.txt
    while [ $? -ne 0 ]; do
        sleep 6
        echo "second try to upload most_recent_article.txt"
        scp -rv -o 'StrictHostKeyChecking no' most_recent_article.txt psicode@www.psicode.org:~/html/feed/most_recent_article.txt
    done
fi

if [[ -f "articles.txt" ]]; then
    echo "first try to upload articles.txt"
    scp -rv -o 'StrictHostKeyChecking no' articles.txt psicode@www.psicode.org:~/html/feed/articles.txt
    while [ $? -ne 0 ]; do
        sleep 6
        echo "second try to upload articles.txt"
        scp -rv -o 'StrictHostKeyChecking no' articles.txt psicode@www.psicode.org:~/html/feed/articles.txt
    done
fi

cd /home/psilocaluser/gits/psi4meta/github-feed/

if [[ -f "most_recent_commit.txt" ]]; then
    echo "first try to upload most_recent_commit.txt"
    scp -rv -o 'StrictHostKeyChecking no' most_recent_commit.txt psicode@www.psicode.org:~/html/feed/most_recent_commit.txt
    while [ $? -ne 0 ]; do
        sleep 6
        echo "second try to upload most_recent_commit.txt"
        scp -rv -o 'StrictHostKeyChecking no' most_recent_commit.txt psicode@www.psicode.org:~/html/feed/most_recent_commit.txt
    done
fi

if [[ -f "commits.txt" ]]; then
    echo "first try to upload commits.txt"
    scp -rv -o 'StrictHostKeyChecking no' commits.txt psicode@www.psicode.org:~/html/feed/commits.txt
    while [ $? -ne 0 ]; do
        sleep 6
        echo "second try to upload commits.txt"
        scp -rv -o 'StrictHostKeyChecking no' commits.txt psicode@www.psicode.org:~/html/feed/commits.txt
    done
fi

