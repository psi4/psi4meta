## A collection of scripts

- `replace_with_make_shared.py` Replaces creation of `std::shared_ptr`-s by using `new` with `std::make_shared`.
  The regex was fine-tuned using [regex101.com](https://regex101.com/)
  **Warning** the script is not 100% foolproof and it might replaces some false positives and ignore some
  false negatives.
- `autofy.py` Replaces the type on the left-hand side of a `std::make_shared` call with `auto`.
  The regex was fine-tuned using [regex101.com](https://regex101.com/)

- `examine_psi4_conda_env.py` was once in `GH/psi4/psi4:psi4/share/psi4/scripts/setenv.py` to test the environment after a conda install. It has some nice snippets for examining shell and libs but was mainly to convince the core devs that conda was sane. That mission was accomplished and script no longer maintained, so removing from main repo.
