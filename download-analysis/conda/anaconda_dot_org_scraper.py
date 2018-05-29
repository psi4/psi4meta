
# coding: utf-8

# In[1]:

from __future__ import print_function
name = '2018-05-29-scrape_binstar'
title = "Binstar/conda package stats"

import os
from datetime import datetime

#from IPython.core.display import HTML

# with open('creative_commons.txt', 'r') as f:
#    html = f.read()

# html = '''
# <small>
# <p> This post was written as an IPython notebook.
#  It is available for <a href='https://ocefpaf.github.com/python4oceanographers/downloads/notebooks/%s.ipynb'>download</a>
#  or as a static <a href='https://nbviewer.ipython.org/url/ocefpaf.github.com/python4oceanographers/downloads/notebooks/%s.ipynb'>html</a>.</p>
# <p></p>
# %s''' % (name, name, html)

#get_ipython().magic(u'matplotlib inline')
from matplotlib import style
style.use('ggplot')

hour = datetime.utcnow().strftime('%H:%M')
comments="true"

date = '-'.join(name.split('-')[:3])
slug = '-'.join(name.split('-')[3:])

metadata = dict(title=title,
                date=date,
                hour=hour,
                comments=comments,
                slug=slug,
                name=name)

markdown = """Title: {title}
date:  {date} {hour}
comments: {comments}
slug: {slug}

{{% notebook {name}.ipynb cells[1:] %}}
""".format(**metadata)

# content = os.path.abspath(os.path.join(os.getcwd(), os.pardir, os.pardir, '{}.md'.format(name)))
# with open('{}'.format(content), 'w') as f:
#     f.writelines(markdown)


# [Conda](http://conda.pydata.org/docs/intro.html) and
# [binstar](https://binstar.org/) are changing the packaging world of Python.
# Conda made it easy to install re-locatable python binaries that where hard
# to build, while binstar provides a "Linux repository-like system"
# (or if you are younger than me an AppStore-like system) to host custom binaries.
# 
# Taking advantage of that [IOOS](http://www.ioos.noaa.gov/) created a binstar
# [channel](https://binstar.org/ioos) with Met-ocean themed packages for Windows,
# Linux and MacOS.  Note that, if you are using Red Hat Enterprise Linux or Centos you
# should use the [rhel6 channel](https://binstar.org/ioos-rhel6) to avoid the
# [GLIBC problem](https://groups.google.com/a/continuum.io/forum/#!topic/conda/_MGxU8vOBPw).
# 
# All the conda-recipes are open and kept in a GitHub
# [repository](https://github.com/ioos/conda-recipes). (And accepting PRs ;-)
# 
# In this post I will not show how to install and configure conda with this channel.
# It has been done already [here](https://ocefpaf.github.io/python4oceanographers/blog/2014/06/23/virtual_env/)
# and
# [here](https://github.com/ioos/conda-recipes/wiki).  Is this post I will scrape
# the binstar channel stats to evaluate how the channel is doing.

# First some handy functions to parse the dates, the package names, and
# to same all the data into a pandas DataFrame.

# In[2]:

import re
import requests
import numpy as np
from datetime import date
from pandas import DataFrame
from bs4 import BeautifulSoup
from dateutil.relativedelta import relativedelta


def todatetime(ul_str):
    upload = re.compile(r'((?P<year>\d+) years?)?( and )?((?P<month>\d+) months?)?( and )?((?P<day>\d+) days?)?( and )?((?P<hour>\d+) hours?)?( and )?((?P<min>\d+) minutes?)?(.*)ago')
    yr = mo = dy = hr = mn = 0
    mobj = upload.match(ul_str)
    if mobj:
        if mobj.group('year'):
            yr = int(mobj.group('year'))
        if mobj.group('month'):
            mo = int(mobj.group('month'))
        if mobj.group('day'):
            dy = int(mobj.group('day'))
        if mobj.group('hour'):
            hr = int(mobj.group('hour'))
        if mobj.group('min'):
            mn = int(mobj.group('min'))
    else:
        raise ValueError("Unexpected period {!r}".format(ul_str))

    delta = relativedelta(years=yr, months=mo, days=dy, hours=hr, minutes=mn)
    return date.today() - delta


def parse_name(cell):
    name = cell.text.strip().split('/')
    if len(name) != 2:
        name = cell.text.strip().split('\\')
    arch = '{}'.format(name[0].split()[1])
    name = '{}'.format(name[1].split('.tar.bz2')[0])
    return arch, name


def get_page(package, page):
    url = "https://anaconda.org/psi4/{}/files?page={}".format
    r = requests.get(url(package, page))
    r.raise_for_status()
    soup = BeautifulSoup(r.text, "html5lib")
    table = soup.find("table", class_="full-width")

    downloads, uploaded, platforms, names = [], [], [], []
    for row in table.findAll('tr'):
        col = row.findAll('td')
        #print('COL: ', col)
        if len(col) == 8:
            downloads.append(int(col[6].text.strip()))
            uploaded.append(todatetime(col[4].text.strip()))
            platform, name = parse_name(col[3])
            platforms.append(platform)
            names.append(name)
            #print downloads[-1], uploaded[-1], platforms[-1], names[-1]
    return downloads, uploaded, platforms, names


def get_df(package):
    downloads, uploaded, platforms, names = [], [], [], []
    for page in range(1, 15):
        dn, up, pf, nm = get_page(package, page)
        print(len(nm), end=' ')
        downloads.extend(dn)
        uploaded.extend(up)
        platforms.extend(pf)
        names.extend(nm)
        if len(nm) != 50:
            break
    else:
        print("Insufficient pages or packages in multiple of 50 which may lead to inflated download counts.")

    df = DataFrame(data=np.c_[platforms, names, uploaded, downloads],
                   columns=['platform', 'name', 'uploaded', 'downloads'])
    df['uploaded'] = pd.to_datetime(df['uploaded'])
    df.set_index('uploaded', inplace=True, drop=True)
    df['downloads'] = df['downloads'].astype(int)
    return df


# All the data we need is in the `repodata.json` file.  There isn't an API
# to access that via the command line (yet), that is why we need to scrape
# it.

# In[3]:

from requests import HTTPError
from pandas import Panel, read_json
import pandas as pd
pd.set_option('display.max_columns', 500)
pd.set_option('display.max_rows', 5000)
pd.set_option('display.width', 1000)

json = "https://conda.anaconda.org/psi4/linux-64/repodata.json"
df = read_json(json)

packages = sorted(set(['-'.join(pac.split('-')[:-2]) for pac in df.index]))
packages = [pkg for pkg in packages if pkg]
packages = [u'psi4', u'chemps2', u'dftd3', u'pcmsolver', u'v2rdm_casscf', u'libint', u'erd', u'simint', u'dkh', u'gdma', u'gcp', u'libefp', 'libxc']

dfs = dict()
for pac in packages:
    try:
        print('\n', pac, ': ', end='')
        dfs.update({pac: get_df(pac)})
    except HTTPError:
        continue

#print(dfs)


# Now let's split the various platforms and compute total number of downloads
# for each package.

# In[13]:

def get_plat_total(df):
    package = dict()

    for plat in ['linux-64', 'osx-64']:  #, 'win-32', 'win-64']:
        # all time
        #sset = df.loc[:].query('platform == "{}"'.format(plat))
        # before 1.0  # 5 Jul 2017 - no longer any good b/c I thinned out the pkgs
        #sset = df.loc['2016-7-4':].query('platform == "{}"'.format(plat))
        # after 1.0
        #sset = df.loc[:'2016-7-4'].query('platform == "{}"'.format(plat))
        # after 1.1
        sset = df.loc[:'2017-5-16'].query('platform == "{}"'.format(plat))
        print(sset)  # nicely formatted output
        total = sset.sum()
        package.update({plat: total['downloads']})
    return package

packages = dict()
for pac in dfs.keys():
    df = dfs[pac]
    packages.update({pac: get_plat_total(df)})

for pac in dfs.keys():
    print('{:<15}: {:<10} {:<6} {:<10} {:<6} {:<10} {:<6}'.format(pac,
          'linux-64', packages[pac]['linux-64'],
          'osx-64', packages[pac]['osx-64'],
          'total', packages[pac]['linux-64'] + packages[pac]['osx-64']))
