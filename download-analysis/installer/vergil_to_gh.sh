export PATH=/home/cdsgroup/miniconda/bin:$PATH
source activate py37
cd /home/cdsgroup/psicode-hugo-website/scripts

python ./google-scholar-citations.py
git diff
git add ../data/pubs/google_scholar_citations.json
git add ../static/images/downloads/*png
git commit -m "crontab updates"
git log --oneline | head
git pull --rebase upstream master
git push upstream master
