#!/home/psilocaluser/toolchainconda/bin/python

# CDS:
# need to get the right python... we have to update the line above if
# python moves (sigh).  /usr/bin/env python3 wouldn't work for me
# when this is called as a crontab (even though it works when called
# as a user).  Only thing I found that worked was hardwiring the path
# above.

# this program creates a list of recent papers citing the Psi4 1.1 paper
# and creates a webpage with this info, suitable for posting at 
# psicode.org

# January 2018, C. David Sherrill


# package bs4: this is installed under the name beautifulsoup4
# it parses HTML elements and is recommended over regular expression 
# parsing for HTML files

# package requests: this grabs webpages

import os, sys, requests, bs4

# were we called with an explict path?  If so, write the files there
dirname = os.path.dirname(sys.argv[0])

# pull over the Google Scholar webpage for the Psi4 1.1 article
# scisbd=1 means 'sort by date' (most recent articles first)
res = requests.get('https://scholar.google.com/scholar?cites=12829015966231637120&hl=en&scipsc=&q=&scisbd=1')
res.raise_for_status() # error out if something went wrong

# parse the webpage into elements
parsed = bs4.BeautifulSoup(res.text, "html.parser")

print(parsed)

# get list of titles with links
titles = parsed.select('.gs_rt a')

# we seem to be getting an extra title lately (our own) for no apparent
# reason... pop that off
titles.pop(0)

# get the list of authors (and journal)
authors = parsed.select('.gs_a')


# write the top (most recent) article to its own file, most_recent_article.txt

f_out = open(dirname + '/most_recent_article.txt', 'w')
f_out.write('<a class="df" href="{}">{}</a>, {}\n'.format(titles[0].get('href'), titles[0].getText(), authors[0].getText()))
f_out.close()


# write all articles to articles.txt

f_out = open(dirname + '/articles.txt', 'w')
f_out.write('<h3>Recent Articles Citing <span style="font-variant: small-caps;">Psi4</span></h3>\n')
f_out.write('<p>\n<ul>\n')

for article_number, title in enumerate(titles):
    article_link = title.get('href')
    article_title = title.getText()
    f_out.write('<li><a href="{}">{}</a><br />\n'.format(article_link, article_title))
    article_ref = authors[article_number].getText()
    # article_ref = article_ref.replace("…", "...")
    f_out.write('{}</li>\n'.format(article_ref))

f_out.write('</ul>\n</p>\n')

f_out.close()

