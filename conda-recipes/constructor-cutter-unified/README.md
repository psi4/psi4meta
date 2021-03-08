* As of March 2021, installers are built via GitHub Action. The cookiecutter method remains locally to test package availability.

* run in an environment that has `cookiecutter` installed. `constructor` must also be accessible.
  * Feb 2021, constructor v3.2.0 (c-f) works while v3.0.2 (def) does not
  * for Windows, also need pillow and nsis (c-f). below allows packages to be collected for windows to test env solvability locally, but resulting installer exe probably bad
  * ln -s /home/psilocaluser/toolchainconda/envs/cookie2021/NSIS/Bin/ /home/psilocaluser/toolchainconda/envs/cookie2021/Bin
  * ln -s /home/psilocaluser/toolchainconda/envs/cookie2021/NSIS/Contrib/ /home/psilocaluser/toolchainconda/envs/cookie2021/Contrib
  * ln -s /home/psilocaluser/toolchainconda/envs/cookie2021/NSIS/Include/ /home/psilocaluser/toolchainconda/envs/cookie2021/Include
  * ln -s /home/psilocaluser/toolchainconda/envs/cookie2021/NSIS/Plugins/ /home/psilocaluser/toolchainconda/envs/cookie2021/Plugins
  * ln -s /home/psilocaluser/toolchainconda/envs/cookie2021/NSIS/Stubs/ /home/psilocaluser/toolchainconda/envs/cookie2021/Stubs

* edit `cookiecutter/cookiecutter.json` for control. edit `cookiecutter/{{.../construct.yaml` for templating

* dir `build/` is regenerated each time.

* may want to clear out ~/.conda/constructor

* `CONSTRUCTOR_CACHE=/psi/gits/constructor_cache python run.py`

* watch out for `py_` in buildstring as this means a noarch and must be eliminated (noarch ok c. 2021)

* `scp -r build/Psi4*/Psi4*sh root@vergil.chemistry.gatech.edu:/var/www/html/psicode-download/`
                           exe

* log in to vergil root and make WindowsWSL symlinks

