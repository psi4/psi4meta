## A collection of scripts

- `replace_with_make_shared.py` Replaces creation of `std::shared_ptr`-s by using `new` with `std::make_shared`.
  The regex was fine-tuned using [regex101.com](https://regex101.com/)
  **Warning** the script is not 100% foolproof and it might replaces some false positives and ignore some
  false negatives.
- `autofy.py` Replaces the type on the left-hand side of a `std::make_shared` call with `auto`.
  The regex was fine-tuned using [regex101.com](https://regex101.com/)
