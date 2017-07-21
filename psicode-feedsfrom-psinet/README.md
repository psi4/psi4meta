psicode feeds from psinet
-------------------------

* these files are *snapshots* from psicode in ``machinations`` directory. The psicode versions aren't under git control.

* ``handle_sphinxman.sh`` is run every quarter hour from a crontab

```bash
*/15 * * * * bash ~/machinations/handle_sphinxman.sh >>~/machinations/ct.log 2>&1
```

* It does:

  * Check if there's a new tarball from psinet in the machinations directory
  * If so, discard backup, copy existing to backup, and untar new into existing, delete tarballs
  * Does this for docs and for github feed
  * Files then in place for website to reference
  * 21 Mar 2017 --- Now does this for doxygen also

