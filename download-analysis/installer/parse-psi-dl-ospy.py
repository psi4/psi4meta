#!/usr/bin/env python

import sys
import getopt
import matplotlib as mpl
mpl.use('Agg') # avoid assuming X backend if we run in cron job
import matplotlib.pyplot as plt
from PIL import Image
import datetime
import collections

# conda install PIL
# conda install -c scitools cartopy
# conda install -c Rufone pycountry

def main(argv):
    input_filename = ''
    output_filename = ''
    unique = False

# getopt(argv, options_string, long_options)
# options_string: colon means takes an argument
# long_options:   optional parameter.  If specified, must be a list
#                 of strings with the names of the long options,
#                 which also need to be caught.  Long options that require
#                 an argument should be followed by an equals sign.
# returns a list of (option, value) pairs, and also 
# a list of the program args left after option list is stripped.
# Each option-and-value pair returned has the option as its first
# element, prefixed with a hyphen for short options or two hyphens
# for long options
 
    try:
        opts, args = getopt.getopt(argv,\
            "hui:o:c:",["unique","ifile=","ofile=","countries_to_plot="])

    except getopt.GetoptError:
        print 'parse-psi-dl.py -i <inputfile> -o <outputfile> [--unique] [-c]'
        sys.exit(2)

    if len(argv) < 1: # note, we already stripped one out before calling main
        print 'parse-psi-dl.py -i <inputfile> -o <outputfile> [--unique] -[-c]'
        sys.exit(2)
    
    for opt, arg in opts:
        if opt == '-h':
            print 'parse-psi-dl.py -i <inputfile> -o <outputfile> [--unique] -[c]'
            sys.exit()
        elif opt in ("-i", "--ifile"):
            input_filename = arg
        elif opt in ("-o", "--ofile"):
            output_filename = arg
        elif opt in ("-u", "--unique"):
            unique = True

    print "Input file is  ", input_filename
    print "Output file is ", output_filename
    print "unique flag is ", unique

# note: the newlines will be part of the lines read,
# so either strip them or don't print additional newlines 
# when printing out
    with open(input_filename, 'r') as infile:
        lines = infile.readlines()

    date_list = []
    time_list = []
    ip_list = []
    os_list = []
    country_list = []
    dl_by_pyos = collections.defaultdict(int)

    for line in lines:
        (date, time, ip, vers, osname, py) = line.split()
        # if --unique, add to list only if we don't already have that ip
        if (ip_list.count(ip) == 0 or not unique) and vers == '1.1':
            dl_by_pyos['{}-Py{}'.format(osname[:3], py)] += 1

    # now sort them back so the small wedges are at starting point
    resorted_pyos = []
    resorted_downloads = []
    for c in sorted(dl_by_pyos.items(), key=lambda (k,v): v):
        resorted_pyos.append(c[0])
        resorted_downloads.append(c[1])

    flag_colors = {
        'Mac-Py36': '#4b6ba9',
        'Mac-Py35': '#4b6ba9',
        'Mac-Py27': '#4b6ba9',
        'Lin-Py36': '#1a4162',
        'Lin-Py35': '#1a4162',
        'Lin-Py27': '#1a4162',
        'Win-Py36': '#a7b2c6',
        'Win-Py35': '#a7b2c6',
        'Win-Py27': '#a7b2c6',
        }

    alt_colors = ['tan', 'purple', 'lightgrey', 'teal', 'goldenrod', '#ce1126', '#63b2be']
    alt_count = 0
    colors = []
    labels = []
    
    i = 0
    for c in resorted_pyos:
        label = c + ' (' + str(resorted_downloads[i]) + ')'
        labels.append(label)
        i += 1
        if c in flag_colors: 
            colors.append(flag_colors[c])
        else:
            if (alt_count < len(alt_colors)):
                colors.append(alt_colors[alt_count])
                alt_count += 1
            else:
                colors.append('gray')

    mpl.rcParams['font.size'] = 10

    # pie chart of the results
    fig = plt.figure(num=1, figsize=(4, 4))
    ax = fig.add_subplot(111)
    patches, texts = ax.pie(resorted_downloads, colors=colors, \
        labels=labels, labeldistance=1.05)
#    The below subplots_adjust would work except that we need axis('equal'), 
#    which forces some dead space vertically that we don't want, to match the
#    dead space horizontally that we do need
#    plt.subplots_adjust(left=0.25, right=0.75, top=0.9, bottom=0.1)
    for p in patches:
        p.set_edgecolor('white')
    for t in texts:
        t.set_size('smaller')
    now = datetime.datetime.now().strftime("%Y-%m-%d")
    if (unique):
        outline = "Unique Psi4 1.1 installer downloads\n2017-05-19 to {}\n".format(now)
    else:
        outline = "Psi4 1.1 installer downloads: {}\n2017-05-19 to {}\n".format(sum(resorted_downloads), now)
    ax.set_title(outline)
    ax.set_xlabel('Not including conda updates or github clones')
    ax.axis('equal') # enforce circular shape, no distortion of plot area
    # padding to avoid clipping of labels
    plt.tight_layout(pad=3.2, w_pad=1.0, h_pad=1.0)
#    plt.show()
    plt.savefig('psitmppyos.png', format='png', transparent=True)

    # clean up file, it needs cropping top and bottom
    img = Image.open('psitmppyos.png')
    x1, y1 = img.size 
    cropped_img = img.crop((0, y1/10, x1, y1-y1/10))
    cropped_img.save('psi-downloads-pie-pyos.png')

 
if __name__ == "__main__":
    main(sys.argv[1:])
