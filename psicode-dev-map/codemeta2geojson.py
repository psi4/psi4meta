import json
import urllib.request
import collections


"""
Takes a codemeta.json file with latitude/longitude information from
Psi4 GitHub (or from local file with a little commenting) and rearranges
it in geojson format for a map of Psi4 developers usable according to
https://help.github.com/articles/mapping-geojson-files-on-github/ .
"""

# rearrange codemeta file

#urllib.request.urlretrieve("https://raw.githubusercontent.com/psi4/psi4/master/codemeta.json", "codemeta.json")
urllib.request.urlretrieve("https://raw.githubusercontent.com/psi4/psi4/loriab-patch-2/codemeta.json", "codemeta.json")
with open("codemeta.json") as fp:
    cm = json.load(fp)


colocate = collections.defaultdict(list)
longlat = {}

for author in cm["author"]:
    fullname = '&nbsp;'.join(filter(None, [author["givenName"], author.get("additionalName"), author["familyName"]]))
    colocate[author["affiliation"]].append(fullname)
    longlat[author["affiliation"]] = [author["longitude"], author["latitude"]]


# construct geojson file

gj = {"type": "FeatureCollection",
      "features": []}

for loc, ppl in colocate.items():
    dloc = {
        "type": "Feature",
        "properties": {loc: '<br/>'.join(ppl)},
        "geometry": {
            "type": "Point",
            "coordinates": longlat[loc],  # yes, it really wants [long, lat]
        }
    }
    gj["features"].append(dloc)

with open("psi4-dev-map.geojson", "w") as fp:
    json.dump(gj, fp, indent=4)
