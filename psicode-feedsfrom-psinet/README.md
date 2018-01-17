psicode feeds from psinet
-------------------------

* Every so often, psinet automatically pushes tarballs over into the ~/machinations directory on psicode

* ``handle_sphinxman.sh`` is run every quarter hour on psicode (using a crontab), to unpack the tarballs

* The information pushed to psicode is from snapshots, and the tarballs themselves are not under git control

* The script to untar everything, handle_sphinxman.sh, is under git control and lives under ~/machinations on psicode

```bash
*/15 * * * * bash ~/machinations/handle_sphinxman.sh >>~/machinations/ct.log 2>&1
```

* It does:

  * Check if there's a new tarball from psinet in the machinations directory
  * If so, discard backup, copy existing to backup, and untar new into existing, delete tarballs
  * Does this for docs and for github feed
  * Files then in place for website to reference
  * 21 Mar 2017 --- Now does this for doxygen also

