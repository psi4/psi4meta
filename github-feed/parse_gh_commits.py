#!/home/psilocaluser/toolchainconda/bin/python

# CDS:
# need to get the right python... we have to update the line above if
# python moves (sigh).  /usr/bin/env python3 wouldn't work for me
# when this is called as a crontab (even though it works when called
# as a user).  Only thing I found that worked was hardwiring the path
# above.

# this program creates a list of recent github commits to the main
# branch of the main psi4 repo, from 
# https://github.com/psi4/psi4/commits/master
# and creates a list of this info suitable to include in a webpage at 
# psicode.org

# February 2018, C. David Sherrill


# package bs4: this is installed under the name beautifulsoup4
# it parses HTML elements and is recommended over regular expression 
# parsing for HTML files

# package requests: this grabs webpages

import os, sys, requests, bs4

# were we called with an explict path?  If so, write the files there
dirname = os.path.dirname(sys.argv[0])

# pull over the webpage of github commits (should already be sorted with
# most recent ones at the top, and only go back a reasonable number of
# commits)
res = requests.get('https://github.com/psi4/psi4/commits/master')
res.raise_for_status() # error out if something went wrong

# parse the webpage into elements
parsed = bs4.BeautifulSoup(res.text, "html.parser")

# get list of commit titles 
xtitles = parsed.select('.commit-title')
# each titles entry has more junk than we need... often it repeats information...
# let's just get the first anchor tag wihin each of these, and within that anchor
# tag, there is a descriptor with the name 'title', e.g.,
#
# <a class="message" data-pjax="true" 
# href="/psi4/psi4/commit/bc46e5fb9841e44fdf4bba118eba6458dea6b342" 
# title="Merge pull request #906 from psi4/loriab-patch-1
# Fixes wB97 &amp; wB97X SAD occupations in dft1 test">Merge pull request</a>

titles = []
commit_hrefs = []
commit_hashes_short = []

# merge commits have multi-line stuff... just take first line
for xtitle in xtitles:
    first_anchor = xtitle.find('a')
    titles.append((first_anchor.get('title').split('\n'))[0])
    href_string = first_anchor.get('href')
    commit_hrefs.append(href_string)
    commit_hashes_short.append(((href_string.split('/'))[-1])[0:7])

# get the list of authors
authors = parsed.select('.commit-author')

# get the times committed
commit_times = parsed.select('.commit-author-section relative-time')


# write all articles to commits.txt

f_out = open(dirname + '/commits.txt', 'w')
f_out.write('<p>\n<ul>\n')

first_written = False

for commit_number, title in enumerate(titles):
    f_out.write('<li> {} by {}<br />\n'.format(commit_times[commit_number].getText(), authors[commit_number].getText()))
    f_out.write('[<a href="https://github.com{}">{}</a>] {}</li><br />\n'.format(commit_hrefs[commit_number], commit_hashes_short[commit_number], title))
    # write the top (most recent) commit to its own file, most_recent_commit.txt
    # let's skip merge commits because they read as less interesting
    if (not(first_written) and not(title[0:18] == "Merge pull request")):
        first_out = open(dirname + '/most_recent_commit.txt', 'w')
        first_out.write('{} by {}:<br />\n'.format(commit_times[commit_number].getText(), authors[commit_number].getText()))
        first_out.write('[<a href="https://github.com{}">{}</a>] {}\n'.format(commit_hrefs[commit_number], commit_hashes_short[commit_number], title))
        first_out.close()
        first_written = True

f_out.write('</ul>\n</p>\n')
f_out.close()

