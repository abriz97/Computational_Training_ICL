Goal of this repo is to check you can create a conda environment using `Python 3.9` with an editable install.

# Create an editable install

Restructure this directoy and create a `pyproject.toml` for a area calculation package named `random_area`.

There should be a `src/random_area/utils` folder with `utils.py` in it and a `src/random_area/area_calc` folder with `area_of_circle.py` within it.

> Hint: https://packaging.python.org/en/latest/guides/writing-pyproject-toml/#writing-pyproject-toml

Now install the package with `pip install -e .` and create an `environment.yaml`

Finally, run `python run.py` from within this directory. If you have done this successfully this will work.

If you get really stuck look in the git history - you can check out SHA `acdffc03de129c19b8917c864e699719bd85226c`

# Update package and rerun

Improve the package by replacing printing with logging and adding seeding for reproducibility

# Extension: Compare speedups

Repeat this for `Python 3.11`

# Extension: Entrypoints

See if you can figure out how to make the same `run.py` run with just a call `circle_area` from the command line

> Hint: https://packaging.python.org/en/latest/guides/writing-pyproject-toml/#creating-executable-scripts