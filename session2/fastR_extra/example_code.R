suppressPackageStartupMessages({
    library(data.table)
    library(ggplot)
})

### Example 1

formulae <- c(
    Sepal.Length ~ Sepal.Width,
    Sepal.Length ~ Petal.Length,
    Sepal.Length ~ Petal.Length + Petal.Width,
    Sepal.Length ~ Petal.Length + Petal.Width + Species
)

# method 1
extract_r2 <- function(formula) {
    fit <- lm(formula, data = iris)
    r2 <- summary(fit)$r.squared
    return(r2)
}

lm_results <- sapply(formulae, extract_r2)
exists("fit")

# method 2
lm_results2 <- c()
for (formula in formulae) {
    fit <- lm(formula, data = iris)
    r2 <- summary(fit)$r.squared
    lm_results2 <- c(lm_results2, r2)
}
exists("fit")


### Example 2

library(parallel)
library(lme4)

f <- function(i) {
    lme4::lmer(Petal.Width ~ . - Species + (1 | Species), data = iris)
}

system.time(save1 <- lapply(1:100, f))
#    user  system elapsed 
#   1.647   0.003   1.651 
system.time(save2 <- mclapply(1:100, f))
#    user  system elapsed 
#   1.002   0.140   1.129 

num_cores <- detectCores()
cl <- makeCluster(num_cores)
system.time(save3 <- parLapply(cl, 1:100, f))
#    user  system elapsed 
#   0.198   0.044   1.032 



## Data. table code

library(data.table)
iris_dt <- as.data.table(iris)

iris_dt[, mean(Sepal.Length), by=Species]
iris_dt[Species == "setosa", mean(Sepal.Length)]
iris_dt[, mean(Sepal.Length), by=Species]
iris_dt[Sepal.Length>5, .N, by=Species]
iris_dt[, .SD[1], by=Species]

iris_dt[, Species_ita := paste0(
    Species, 'ino'
), by=Species]
iris_dt[, unique(Species_ita)]

iris_dt[, Species_ita := gsub(
    "aino","ino",
    Species_ita
), by=Species_ita]
iris_dt[, unique(Species_ita)]

numeric_cols <- names(iris_dt)[sapply(iris_dt, is.numeric)]
iris_dt[, lapply(
    .SD, as.integer
), .SDcols = numeric_cols] |> head(2)

new_cols <- paste0(numeric_cols, "_int")
iris_dt[, (new_cols) := lapply(
    .SD, as.integer
), .SDcols = numeric_cols]; head(iris_dt, n=2)
