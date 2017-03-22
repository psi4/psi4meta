psinet nightly
--------------

21 March 2017

Assume everything below this section marker is out of date.

* [psinet-nightly/handle_sphinxman.sh](handle_sphinxman.sh)

  * The Linux+Py35 conda build deposits sphinxman, feed, and doxygen tarballs into folder `psicode_dropbox/` on psinet.
  * The above script checks for those tarballs every 7 min, then sends them to psicode.org (sshkey auth) and upon success deletes them.
  * psinet crontab: `*/7 * * * * bash /theoryfs2/ds/cdsgroup/psi4-compile/psi4meta/psinet-nightly/handle_sphinxman.sh >/theoryfs2/ds/cdsgroup/psi4-compile/psi4meta/psinet-nightly/psicode-dropbox.log 2>&1`
  * On psicode.org, [psicode-feedsfrom-psinet/handle_sphinxman.sh](../psicode-feedsfrom-psinet/handle_sphinxman.sh) checks for tarballs every 15 min and unpacks them into position.

-----

* ``nightlycondabuildctestcdash.sh`` is run nightly from a crontab

```bash
00 02 * * * /theoryfs2/ds/cdsgroup/psi4-compile/nightly/nightlycondabuildctestcdash.sh >/theoryfs2/ds/cdsgroup/psi4-compile/nightly/cb-psinet.log 2>&1
```

* It does:

  * Build of Linux conda package from fresh ``psi4/psi4`` checkout
  * If a few test cases pass, upload conda package to anaconda.org
  * Run **all** test cases, send results to testboard.org
  * Make docs. If successful, tgz and send to psicode for "docs" link in header
  * Make github feed. If successful, tgz and send to psicode for single commit on main page and recent history on ``timeline.php``

* Many comments in script itself

* Accessible to anyone with a cdsgroup account after talking about some details.

* **Takeaway: everything built from private repo at 2 AM**

* Fork conda package so users can subscribe just to psi4 channel
  * >>> ``~/psi4-install/miniconda/bin/anaconda copy asmeurer/gsl/1.16/linux-64/gsl-1.16-1.tar.bz2``

* 23 January 2016

  * fresh miniconda installation
    * `conda install conda-build=1.18.0`  # current is 1.18.2 but they changed their jinja2 parsing and our versioning hasn't been updated to compatibility
    * `conda install jinja2`
    * `conda install anaconda-client`  # needed to upload to anaconda.org
    * unnecessary for me since login transferred from prev installation, but generally `anaconda login`

