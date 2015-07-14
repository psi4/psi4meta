psinet nightly
--------------

* ``nightlycondabuildctestcdash.sh`` is run nightly from a crontab

```bash
00 02 * * * /theoryfs2/ds/cdsgroup/psi4-compile/nightly/nightlycondabuildctestcdash.sh >/theoryfs2/ds/cdsgroup/psi4-compile/nightly/cb-psinet.log 2>&1
```

* It does:

  * Build of Linux conda package from fresh ``psi4/psi4`` checkout
  * If a few test cases pass, upload conda package to anaconda.org
  * Run **all** test cases, send results to testboard.org
  * Make docs. If successful, tgz and send to psicode
  * Make github feed. If successful, tgz and send to psicode

* Many comments in script itself

* Accessible to anyone with a cdsgroup account after talking about some details.

