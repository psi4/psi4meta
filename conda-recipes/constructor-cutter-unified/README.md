
* run in an environment that has `cookiecutter` installed. `constructor` must also be accessible.

* edit `cookiecutter/cookiecutter.json` for control. edit `cookiecutter/{{.../construct.yaml` for templating

* dir `build/` is regenerated each time.

* may want to clear out ~/.conda/constructor

* `python run.py`

* watch out for `py_` in buildstring as this means a noarch and must be eliminated

* `scp -r build/Psi4*/Psi4*sh root@vergil.chemistry.gatech.edu:/var/www/html/psicode-download/`

* log in to vergil root and make WindowsWSL symlinks

