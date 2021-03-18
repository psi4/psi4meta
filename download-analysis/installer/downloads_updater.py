#!/usr/bin/env python

import re, datetime, calendar

cummfile = 'downloads.txt'
#cummfile = 'testdownloads.txt'

# open the existing list of downloads and get the last timestamp
with open(cummfile, 'r') as dlfile:
    downloads = dlfile.readlines()
(date, time, ip, vers, osname, py) = downloads[-1].split()
buf = "%s %s" % (date, time)
# strptime converts a string to a datetime
lastdl = datetime.datetime.strptime(buf, '%Y-%m-%d %H:%M')
#print lastdl

p4dl = re.compile(r"""^(?P<loc>[0-9.]+) - - \[(?P<day>[0-9]*)\/(?P<month>.*)\/(?P<year>[0-9]*):(?P<hour>[0-9]*):(?P<min>[0-9]*).*\] "GET\s*./psicode-download/[Pp]si4conda-(?P<p4ver>.*?)-py(?P<p4py>[23][0-9]+)-(?P<p4os>.*?)-x86_64.(sh|exe).*$""", re.MULTILINE)

# copy the access_log from /etc/httpd/logs/access_log
lines = open('access_log').read()
# ans will be a list of tuples
ans = p4dl.findall(lines)
#print(ans)

# sample script output with two matches
#[('73.237.231.197', '15', 'May', '2017', '03', '47', '1.1rc1', '35', 'MacOSX'), ('73.237.231.197', '15', 'May', '2017', '04', '45', '1.1rc1', '27', 'Windows')]

with open(cummfile, 'a') as outfile:

    for dl in ans:
        # print dl
        month = list(calendar.month_abbr).index(dl[2])
        timestamp = datetime.datetime(int(dl[3]), month, int(dl[1]), int(dl[4]), int(dl[5]))
        if (timestamp > lastdl): # this is not in our list yet
            # print "%s > %s\n" % (timestamp, lastdl)
            tsstring = timestamp.strftime("%Y-%m-%d %H:%M")
            #   timestamp IP  vers OS Py
            buf = "%s %-15s %-8s %-12s %-4s\n" % (tsstring, dl[0], dl[6], dl[8], dl[7])
            # print buf
            outfile.write(buf)

# then need to rewrite analyzer to ignore the new fields
