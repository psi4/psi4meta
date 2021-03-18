#!/usr/bin/env python

import sys
import getopt
import matplotlib as mpl
mpl.use('Agg') # avoid assuming X backend if we run in cron job
import matplotlib.pyplot as plt
from PIL import Image
import datetime
import collections
from pathlib import Path

# conda install PIL
# conda install -c scitools cartopy
# conda install -c Rufone pycountry

def main(argv):
    input_filename = ''
    output_filename = ''
    unique = False
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
        opts, args = getopt.getopt(argv,
            "hui:o:d:",["unique","ifile=","ofile=","odir="])

    except getopt.GetoptError:
        print('parse-psi-dl.py -i <inputfile> -o <outputfile> [--unique] [-d]')
        sys.exit(2)

    if len(argv) < 1: # note, we already stripped one out before calling main
        print('parse-psi-dl.py -i <inputfile> -o <outputfile> [--unique] -[-d]')
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            print('parse-psi-dl.py -i <inputfile> -o <outputfile> [--unique] -[d]')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            input_filename = arg
        elif opt in ("-o", "--ofile"):
            output_filename = arg
        elif opt in ("-u", "--unique"):
            unique = True
        elif opt in ("-d", "--odir"):
            odir = Path(arg)


    print(f"Input file is  {input_filename}")
    print(f"Output file is {output_filename}")
    print(f"unique flag is {unique}")
    print(f"Output dir is  {odir}")

    flag_colors = {
        'Mac':      '#4b6ba9',
        'Mac-Py39': '#4b6ba9',
        'Mac-Py38': '#4b6ba9',
        'Mac-Py37': '#4b6ba9',
        'Mac-Py36': '#4b6ba9',
        'Mac-Py35': '#4b6ba9',
        'Mac-Py27': '#4b6ba9',
        'Lin':      '#1a4162',
        'Lin-Py39': '#1a4162',
        'Lin-Py38': '#1a4162',
        'Lin-Py37': '#1a4162',
        'Lin-Py36': '#1a4162',
        'Lin-Py35': '#1a4162',
        'Lin-Py27': '#1a4162',
        'WSL':      '#a7b2c6',
        'WSL-Py39': '#a7b2c6',
        'WSL-Py38': '#a7b2c6',
        'WSL-Py37': '#a7b2c6',
        'WSL-Py36': '#a7b2c6',
        'WSL-Py35': '#a7b2c6',
        'WSL-Py27': '#a7b2c6',
        'Win':      '#394458',
        'Win-Py39': '#394458',
        'Win-Py38': '#394458',
        'Win-Py37': '#394458',
        'Win-Py36': '#394458',
        'Win-Py35': '#394458',
        'Win-Py27': '#394458',
        }

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

    dl_by_pyos_v10 = collections.defaultdict(int)
    dl_by_pyos_v11 = collections.defaultdict(int)
    dl_by_pyos_v12 = collections.defaultdict(int)
    dl_by_pyos_v13 = collections.defaultdict(int)
    dl_by_pyos_v14 = collections.defaultdict(int)
    dl_by_pyos_v15 = collections.defaultdict(int)
    dl_by_pyos_v16 = collections.defaultdict(int)
    dl_by_pyos_v17 = collections.defaultdict(int)

    dl_by_pyos_2017 = collections.defaultdict(int)
    dl_by_pyos_2018 = collections.defaultdict(int)
    dl_by_pyos_2019 = collections.defaultdict(int)
    dl_by_pyos_2020 = collections.defaultdict(int)
    dl_by_pyos_2021 = collections.defaultdict(int)
    dl_by_pyos_2022 = collections.defaultdict(int)
    dl_by_pyos_2023 = collections.defaultdict(int)
    dl_by_pyos_2024 = collections.defaultdict(int)

    for line in lines:
        (date, time, ip, vers, osname, py) = line.split()

        if osname == "Windows" and vers == "1.1":
            osname = "WSL"
        elif osname == "WindowsWSL":
            osname = "WSL"
        else:
            osname = osname[:3]

        # if --unique, add to list only if we don't already have that ip
        if (not unique or ip_list.count(ip) == 0):
            if vers.startswith('1.0'):
                dl_by_pyos_v10[f'{osname}-Py{py}'] += 1
            elif vers.startswith('1.1'):
                dl_by_pyos_v11[f'{osname}-Py{py}'] += 1
            elif vers.startswith('1.2'):
                dl_by_pyos_v12[f'{osname}-Py{py}'] += 1
            elif vers.startswith('1.3'):
                dl_by_pyos_v13[f'{osname}-Py{py}'] += 1
            elif vers.startswith('1.4'):
                dl_by_pyos_v14[f'{osname}-Py{py}'] += 1
            elif vers.startswith('1.5'):
                dl_by_pyos_v15[f'{osname}-Py{py}'] += 1
            elif vers.startswith('1.6'):
                dl_by_pyos_v16[f'{osname}-Py{py}'] += 1
            elif vers.startswith('1.7'):
                dl_by_pyos_v17[f'{osname}-Py{py}'] += 1

            if date.startswith('2017'):
                dl_by_pyos_2017[f'{osname}-v{vers}'] += 1
            elif date.startswith('2018'):
                dl_by_pyos_2018[f'{osname}-v{vers}'] += 1
            elif date.startswith('2019'):
                dl_by_pyos_2019[f'{osname}-v{vers}'] += 1
            elif date.startswith('2020'):
                dl_by_pyos_2020[f'{osname}-v{vers}'] += 1
            elif date.startswith('2021'):
                dl_by_pyos_2021[f'{osname}-v{vers}'] += 1
            elif date.startswith('2022'):
                dl_by_pyos_2022[f'{osname}-v{vers}'] += 1
            elif date.startswith('2023'):
                dl_by_pyos_2023[f'{osname}-v{vers}'] += 1
            elif date.startswith('2024'):
                dl_by_pyos_2024[f'{osname}-v{vers}'] += 1


    def figure_from_count_dict(label, dicary):
        if len(dicary) == 0:
            return

        print(f'\n<<<  {label}  >>>\n')
        # now sort them back so the small wedges are at starting point
        resorted_pyos = []
        resorted_downloads = []
        for c in sorted(dicary.items(), key=lambda k: k[1]):
            resorted_pyos.append(c[0])
            resorted_downloads.append(c[1])
            print(c)

        alt_colors = ['tan', 'purple', 'lightgrey', 'teal', 'goldenrod', '#ce1126', '#63b2be']
        alt_count = 0
        colors = []
        labels = []
        min_label = int(0.018 * sum(resorted_downloads))

        for i, c in enumerate(resorted_pyos):
            if resorted_downloads[i] > min_label:
                labels.append(f"{c.replace('v', '')} ({resorted_downloads[i]})")
            else:
                labels.append('')

            if c in flag_colors:
                colors.append(flag_colors[c])
            elif c[:3] in flag_colors:
                colors.append(flag_colors[c[:3]])
            else:
                if (alt_count < len(alt_colors)):
                    colors.append(alt_colors[alt_count])
                    alt_count += 1
                else:
                    colors.append('gray')

        mpl.rcParams['font.size'] = 10

        # pie chart of the results
        fig = plt.figure(num=1, figsize=(4, 4))
        ax = fig.add_subplot(111, label=label)
        patches, texts = ax.pie(resorted_downloads, colors=colors, labels=labels, labeldistance=1.05)
        # The below subplots_adjust would work except that we need axis('equal'),
        #   which forces some dead space vertically that we don't want, to match the
        #   dead space horizontally that we do need
        #plt.subplots_adjust(left=0.25, right=0.75, top=0.9, bottom=0.1)
        for p in patches:
            p.set_edgecolor('white')
        for t in texts:
            t.set_size('smaller')
        now = datetime.datetime.now().strftime("%Y-%m-%d")
        uniq = "Unique " if unique else ""
        if label.startswith('v'):
            startdate = '2017-05-19'
            enddate = now
        elif label.startswith('20'):
            startdate = '2017-05-19' if label == '2017' else f'{label}-01-01'
            enddate = now if now.startswith(label) else f'{label}-12-31'
        outline = f"{uniq}Psi4 {label} installer downloads: {sum(resorted_downloads)}\n{startdate} to {enddate}\n"

        ax.set_title(outline)
        print(outline)
        ax.set_xlabel('Not including conda updates or github clones')
        ax.axis('equal')  # enforce circular shape, no distortion of plot area
        # padding to avoid clipping of labels
        plt.tight_layout(pad=3.2, w_pad=1.0, h_pad=1.0)
        plt.savefig('psitmppyos.png', format='png', transparent=True)
        plt.close()

        # clean up file, it needs cropping top and bottom
        img = Image.open('psitmppyos.png')
        x1, y1 = img.size
        cropped_img = img.crop((0, y1/10, x1, y1-y1/10))
        cropped_img.save(odir / f'psi-downloads-pie-pyos-{label}.png')

    figure_from_count_dict('v1.0', dl_by_pyos_v10)
    figure_from_count_dict('v1.1', dl_by_pyos_v11)
    figure_from_count_dict('v1.2', dl_by_pyos_v12)
    figure_from_count_dict('v1.3', dl_by_pyos_v13)
    figure_from_count_dict('v1.4', dl_by_pyos_v14)
    figure_from_count_dict('v1.5', dl_by_pyos_v15)
    figure_from_count_dict('v1.6', dl_by_pyos_v16)
    figure_from_count_dict('v1.7', dl_by_pyos_v17)

    figure_from_count_dict('2017', dl_by_pyos_2017)
    figure_from_count_dict('2018', dl_by_pyos_2018)
    figure_from_count_dict('2019', dl_by_pyos_2019)
    figure_from_count_dict('2020', dl_by_pyos_2020)
    figure_from_count_dict('2021', dl_by_pyos_2021)
    figure_from_count_dict('2022', dl_by_pyos_2022)
    figure_from_count_dict('2023', dl_by_pyos_2023)
    figure_from_count_dict('2024', dl_by_pyos_2024)


if __name__ == "__main__":
    main(sys.argv[1:])
