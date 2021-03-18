#!/usr/bin/env python

import sys
import getopt
import geoip2.database
import matplotlib as mpl
mpl.use('Agg') # avoid assuming X backend if we run in cron job
import matplotlib.pyplot as plt
from PIL import Image
import cartopy.crs as ccrs
import cartopy.io.shapereader as shpreader
import datetime
import collections
from pathlib import Path

# [original]
# conda install PIL
# conda install -c scitools cartopy
# conda install -c Rufone pycountry

# [Jul 2019]
# conda create -n py37 matplotlib pycountry cartopy pandas beautifulsoup4 python=3.7 -c conda-forge
# pip install geoip2
# * downloaded static database from https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz


def main(argv):
    input_filename = ''
    output_filename = ''
    unique = False
    countries_to_plot = 12
    odir = Path('.')

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
            "hui:o:c:d:",["unique","ifile=","ofile=","countries_to_plot=","odir="])

    except getopt.GetoptError:
        print('parse-psi-dl.py -i <inputfile> -o <outputfile> [--unique] [-c]')
        sys.exit(2)

    if len(argv) < 1: # note, we already stripped one out before calling main
        print('parse-psi-dl.py -i <inputfile> -o <outputfile> [--unique] -[-c]')
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            print('parse-psi-dl.py -i <inputfile> -o <outputfile> [--unique] -[c]')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            input_filename = arg
        elif opt in ("-o", "--ofile"):
            output_filename = arg
        elif opt in ("-u", "--unique"):
            unique = True
        elif opt in ("-c", "--countries_to_plot"):
            countries_to_plot = arg
        elif opt in ("-d", "--odir"):
            odir = Path(arg)

    print(f"Input file is  {input_filename}")
    print(f"Output file is {output_filename}")
    print(f"unique flag is {unique}")
    print(f"countries to plot {countries_to_plot}")
    print(f"Output dir is  {odir}")

# note: the newlines will be part of the lines read,
# so either strip them or don't print additional newlines
# when printing out
    with open(input_filename, 'r') as infile:
        lines = infile.readlines()

    if (output_filename != ''):
        outfile = open(output_filename, 'w')
    else:
        outfile = sys.stdout

    date_list = []
    time_list = []
    ip_list = []
    os_list = []
    country_list = []
    dl_by_cc = collections.defaultdict(int)
    cc_lookup = {}

    reader = geoip2.database.Reader('/home/cdsgroup/psi4meta/download-analysis/installer/GeoLite2-Country_20190730/GeoLite2-Country.mmdb')

    for line in lines:
        (date, time, ip, vers, osname, py) = line.split()
        # if --unique, add to list only if we don't already have that ip
        if (ip_list.count(ip) == 0 or not unique): # and date.startswith('2019') and not vers.startswith('1.3'):
            try:
                response = reader.country(ip)
            except:
                print('AddressNotFoundError so skipping', ip)
                continue

            date_list.append(date)
            time_list.append(time)
            ip_list.append(ip)
            os_list.append(osname)
            cc = response.country.iso_code
            countryname = response.country.name
            country_list.append(countryname)
            cc_lookup[cc] = countryname
            dl_by_cc[cc] += 1

    reader.close()

    count = len(date_list)
    outfile.write("{} {}unique downloads\n".format(count, "" if unique else "non-"))

    for i in range(count):
        date = date_list[i]
        time = time_list[i]
        ip = ip_list[i]
        countryname = country_list[i]
        outline = '{} {} {:15} {}\n'.format(date, time, ip, countryname)
        outfile.write(outline)

    outfile.write("\nDownloads by country, using {}unique IP addresses:\n".format("" if unique else "non-"))

    total_downloads = 0
    countries_plotted = 0
    sorted_dl_by_country = {}
    for c in sorted(dl_by_cc.items(), key=lambda k: k[1], reverse=True):
        if c[0]:
            countryname = cc_lookup[c[0]]
        else:
            countryname = 'Unknown'
        outline = '{:25} {:5}\n'.format(countryname, c[1])
        outfile.write(outline)
        total_downloads = total_downloads + c[1]
        if (countries_plotted < countries_to_plot):
            # get rid of any characters after a comma
            countryname = countryname.split(',', 1)[0]
            sorted_dl_by_country[countryname] = c[1]
            countries_plotted = countries_plotted + 1
        elif (countries_plotted == countries_to_plot):
            countryname = 'Other'
            sorted_dl_by_country[countryname] = c[1]
            countries_plotted = countries_plotted + 1
        else:
            countryname = 'Other'
            sorted_dl_by_country[countryname] = \
                sorted_dl_by_country[countryname] + c[1]

    outline = '{:-^31}\n'.format('-')
    outfile.write(outline)
    outline = '{:25} {:5}\n'.format('Total', total_downloads)
    outfile.write(outline)
    outfile.write('\n')

    # now sort them back so the small wedges are at starting point
    resorted_countries = []
    resorted_downloads = []
    for c in sorted(sorted_dl_by_country.items(), key=lambda k: k[1]):
        resorted_countries.append(c[0])
        resorted_downloads.append(c[1])

    flag_colors = {
        'Brazil': '#009b3a',
        'Canada': '#ff0000',
        'China': '#fe0000',
        'Colombia': '#fcd116',
        'France': '#002395',
        'Germany': '#ffcc00',
        'India': '#ff9933',
        'Indonesia': '#ce1126',
        'Iran': '#239f40',
        'Japan': '#bc002d',
        'Korea': '#003478',
        'Norway': '#002868',
        'Romania': '#ce1126',
        'Serbia': '#edb92e',
        'Spain': '#ffc400',
        'Sweden': '#006aa7',
        'Switzerland': '#ff0000',
        'Turkey': '#e30a17',
        'United States': '#0052a5',
        'United Kingdom': '#003399',
        'Viet Nam': '#ffff00',
        'Other': '#63b2be'
        }

    alt_colors = ['tan', 'purple', 'lightgrey', 'teal', 'goldenrod']
    alt_count = 0
    colors = []
    labels = []

    i = 0
    for c in resorted_countries:
        label = c + '(' + str(resorted_downloads[i]) + ')'
        labels.append(label)
        i = i + 1
        if (c in flag_colors):
            colors.append(flag_colors[c])
        else:
            if (alt_count < len(alt_colors)):
                colors.append(alt_colors[alt_count])
                alt_count = alt_count + 1
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
    uniq = 'Unique ' if unique else ''
    outline = f"{uniq}Psi4 installer downloads: {sum(resorted_downloads)}\n2016-07-13 to {now}\n"

    ax.set_title(outline)
    ax.set_xlabel('Not including conda updates or github clones')
    ax.axis('equal') # enforce circular shape, no distortion of plot area
    # padding to avoid clipping of labels
    plt.tight_layout(pad=3.2, w_pad=1.0, h_pad=1.0)
#    plt.show()
    plt.savefig('psitmp.png', format='png', \
        transparent=True)

    # clean up file, it needs cropping top and bottom
    img = Image.open('psitmp.png')
    x1, y1 = img.size
    cropped_img = img.crop((0, y1/10, x1, y1-y1/10))
    cropped_img.save(odir / 'psi-downloads-pie.png')

### World Map! ###

    # set color mapping first
    #bin_mins = [1, 5, 10, 20, 30, 50, 75, 100, 200]  # pre July 2019
    bin_mins = [5, 20, 50, 100, 200, 300, 400, 500, 1000]
    num_colors = len(bin_mins)
    cm = plt.cm.get_cmap('Greens', num_colors)

    # now plot the map
    shapename = 'admin_0_countries'
    countries_shp = shpreader.natural_earth(resolution='110m',
        category='cultural', name=shapename)
    fig = plt.figure(num=2, figsize=(5.5,3))
    ax = plt.axes(projection=ccrs.PlateCarree())
    for country in shpreader.Reader(countries_shp).records():
        cc = country.attributes['ISO_A2']
        if (cc in dl_by_cc and dl_by_cc[cc] < bin_mins[0]):
            ax.add_geometries(country.geometry, ccrs.PlateCarree(),
              facecolor='#ffffff')
        elif cc in dl_by_cc:
            hbin = 0
            for bin_min in bin_mins[1:]:
                if (dl_by_cc[cc] < bin_min):
                    break
                else:
                    hbin += 1
            #print(f"""Country {country.attributes['NAME_LONG']:25} dl {dl_by_cc[cc]:5} bin {hbin:2} color {cm(hbin)[2]:7}\n""")

            ax.add_geometries(country.geometry, ccrs.PlateCarree(),
              facecolor=cm(hbin))
        elif (country.attributes['NAME_LONG'] != 'Antarctica'):
            ax.add_geometries(country.geometry, ccrs.PlateCarree(),
              facecolor='#ffffff')

    # make a color bar legend

    # rectangle in add_axes is rect[left, bottom, width, height], all in
    # fractions of the figure width and height
    ax_legend = fig.add_axes([0.1, 0.14, 0.8, 0.03])
    cb = mpl.colorbar.ColorbarBase(ax_legend, cmap=cm,
        ticks=list(range(num_colors + 1)), boundaries=list(range(num_colors + 1)), orientation='horizontal')
#[0,1,2,3,4,5,6,7,8,9],
        #boundaries=[0,1,2,3,4,5,6,7,8,9], orientation='horizontal')
    xticklabels = [str(i) for i in bin_mins]
    xticklabels[-1] = str(bin_mins[-1]) + "+"
    cb.ax.set_xticklabels(xticklabels)

    # plot it
    plt.tight_layout(pad=0.0, w_pad=0.0, h_pad=0.0)
    plt.savefig('psitmp2.png', format='png',
        transparent=True)

    # clean up file, chop out black border
    img = Image.open('psitmp2.png')
    x1, y1 = img.size
    cropped_img = img.crop((x1/50, y1/20, x1-x1/50, y1-y1/20))
    cropped_img.save(odir / 'psi-downloads-map.png')


if __name__ == "__main__":
    main(sys.argv[1:])
