# :ok_hand: Structuring your R directory[^1]

[^1]: (A `*.md` file without emoji IS NOT a `*.md` file)

## :pushpin: A typical directory

Inspired from [this blog]([r-bloggers.com/2018/08/structuring-r-projects](https://www.r-bloggers.com/2018/08/structuring-r-projects/)) adapted with my own experience.

This document is more of a general guideline rather than a strict rule to adhere to.

A typical structure, which you can recreate by unzipping the [`template.zip`](./template.zip) file a desired location[^2], is presented below:
[^2]: (The idea was to provide a template to R's version of `cookiecutter`, but I wasn't successful in making it work properly)

```
.
└── my_project
    ├── R
    ├── src
    ├── output
    ├── data
    │   ├── raw
    │   └── processed
    ├── README.md
    ├── run_analyses.R 
    └── .gitignore
```

The repository is divided into subdirectories with different aims.

- `data`
    - Contains all data used in the project.
    - You may want to split your data into `raw` and `processed` directories depending on whether it is "source" (read-only) data or "generated" (disposable).
    - If the dataset is too large, storing it in a separate location is common.
    In this case, I would suggest having a `R/paths.R` file where you define the paths to all the data files you use in your project.

It is common practice to  "keep function definition and application separate".

- `R` (_definition_ folder)
    - this is where you store your function definitions.
    - sourcing these files will exclusively load the functions into the global environment.
- `src` (_application_ folder)
    - this is where you store your scripts which aim to generate something
    That is, files where functions are defined are not those in which functions are applied.

You will likely want to save outputs to a specific folder. It makes sense to further subdivide by type of output file.

- `output`
    - typically with subfolders such as `figures`, `tables`, `reports`, etc.

- `run_analyses.R`
    - this is the script you run to generate the results of your project.

## :file_folder: Example [^1]

This is an example from one of my projects:

```
├── data
│   └── ...
├── dependencies.sh
├── R
│   ├── paths.R
│   ├── postprocessing_functions.R
│   ├── postprocessing_mixing.R
│   ├── preprocessing_functions.R
│   └── ...
├── README.md
├── run_sims.sh
├── run_stan.sh
├── src
│   ├── 00_simulation_analyses.R
│   ├── 01_define_study_population.R
│   ├── 02_fit_msm.R
│   ├── 03_postprocessing.R
│   ├── compare_models.R
│   └── fit_msm_frequentist.R
└── stan
    ├── multistate_anova
    ├── multistate_anova.stan
    ├── stan_args_test.yml
    ├── stan_args.yml
    ├── README.md
    └── ...
```

## :fire: Advanced Topics

* If you plan to package your `R` code, you may want to refer to [R package book](http://r-pkgs.had.co.nz/).
* If you really care about reproducibility, conside [orderly](https://cran.r-project.org/web/packages/orderly/vignettes/orderly.html)
