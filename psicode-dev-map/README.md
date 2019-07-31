* [codemeta2geojson.py](codemeta2geojson.py) is a script that
  pulls the https://github.com/psi4/psi4/blob/master/codemeta.json
  file from the Psi4 repo and rearranges it into a geojson file
  [psi4-dev-map.geojson](psi4-dev-map.geojson) that can be served up
  by http://psicode.org/developers.php .
* *Not* generated automatically when codemeta.json changes. Someday
  when we figure out the website, that's a thing to do.

