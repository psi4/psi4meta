#!/bin/tcsh

# I think this user already has this in the path
set MYDIR = /home/cdsgroup/psi4meta/PSIDownloadAnalyzer
#set MINICONDA = /theoryfs2/ds/cdsgroup/miniconda/bin

echo "analyze-downloads.tcsh: about to execute"
date

#set path = ($MINICONDA $path)
#echo `which python`
cd $MYDIR

# we assume a privileged account has already made the access_log file
# from /var/log/httpd/access_log available in the current directory
#
# first, update our downloads.txt file with the info grabbed from
# access_log
#
./downloads_updater.py

# now run the parser to make graphs, etc.
./parse-psi-dl.py -i downloads.txt -o downloads_analysis.txt

rm -f psitmp.png
rm -f psitmp2.png

echo "analyze-downloads.tcsh: execution completed"
date

