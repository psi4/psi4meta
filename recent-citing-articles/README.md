# recent citing articles

C. David Sherrill
January 2018

I've set up a crontab as user psilocaluser to run this script once per week.
The script goes to Google Scholar and pulls over the list of
articles citing the Psi4 1.1 article (I believe the most recent one is
at the top).  It then creates two files, articles.txt and first_article.txt.
These are formatted in HTML and suitable for inclusion inside webpages at
psicode.org.

first_article.txt is inserted at the bottom of the home page, along with a link
to the full list, which is in a webpage that includes articles.txt.

This information gets sent over to psicode periodically, via 
psi4meta/psinet-nightly/push_feed.sh

