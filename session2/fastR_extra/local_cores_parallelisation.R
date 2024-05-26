require(foreach)
require(doParallel)

# sets up parallel backend and redirects output to .parallel_log_

n.cores <- min(4, parallel::detectCores() - 1)

logname <- Sys.time() |> format("%m%d_%H%m")
logname <- paste0(".parallel_log_", logname)
my.cluster <- parallel::makeCluster(
    n.cores,
    type = "FORK",
    outfile = logname
)
doParallel::registerDoParallel(cl = my.cluster)
print(my.cluster)
