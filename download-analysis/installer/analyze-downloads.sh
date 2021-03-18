#!/bin/bash

source activate py37

echo "analyze-downloads.sh: about to execute"
date

cd /home/cdsgroup/psi4meta/download-analysis/installer

# we assume a privileged account has already made the access_log file
# from /var/log/httpd/access_log available in the current directory
#
# first, update our downloads.txt file with the info grabbed from
# access_log
#
./downloads_updater.py

# now run the parser to make graphs, etc.
./parse-psi-dl-ospy.py -i downloads.txt -o downloads_analysis_pyos.txt --odir /home/cdsgroup/psicode-hugo-website/static/images/downloads/
./parse-psi-dl.py -i downloads.txt -o downloads_analysis.txt --odir /home/cdsgroup/psicode-hugo-website/static/images/downloads/

rm -f psitmp.png
rm -f psitmp2.png
rm -f psitmppyos.png

echo "analyze-downloads.sh: execution completed"
date

