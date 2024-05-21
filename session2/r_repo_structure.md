
Notes from [blog]([r-bloggers.com/2018/08/structuring-r-projects](https://www.r-bloggers.com/2018/08/structuring-r-projects/)) adapted with my own experience.

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



The `template.zip` file contains a template for this specific R structure.
You can `unzip template.zip`  to create a new project directory [^1]

[^1]: (The idea was to provide a template to R's version of `cookiecutter`, but I wasn't successful in making it work property)

More of a general guideline rather than a strict rule to adhere to.
However, if you know you want to make a R package, you may want to refer to [R package book](http://r-pkgs.had.co.nz/).


- `data`
    - Contains all data used in the project.
    - You may want to split your data into `raw` and `processed` directories depending on whether it is "source" (read-only) data or "generated" (disposable).
    - If the dataset is too large, it is common to store it in a separate location.
    In this case, I would suggest having a `paths.R` file where you define the paths to all the data files you use in your project.

Common to  "keep function definition and application separate".

- `R` (_definition_ folder)
    - this is where you store your function definitions.
    - sourcing these files will exclusively load the functions into the global environment.
- `src` (_application_ folder)
    - this is where you store your scripts which aim to generate something
    That is, files where functions are defined are not those in which functions are applied.

- `output`
    - typically with subfolders such as `figures`, `tables`, `reports`, etc.

- `run_analyses.R`
    - this is the script you run to generate the results of your project.


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
