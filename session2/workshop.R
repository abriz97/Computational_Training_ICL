library(data.table)
library(ggplot2)
library(here)

repo_path <- here()
data_dir <- file.path(repo_path, "session2/data")

# Say you and your 2 best friends want to go away for a weekend to either ..., ..., or ...
# You want to go to the cheapest AirBNB which satisfies some constraints:
# - host is a super host
# - 3 people
# - cleanliness rating is at least 8.
# - guest satisfaction 0 to 100, at least 90
# - keep 2 extra columns still to determine
# For each city, extract 20 cheapest accomodations satistyinf criteria

# Load the data

# Subset the data to only some columns
data_paths <- file.path(
    repo_path, 
    "session2/data",
    c(
        "amsterdam_weekends.csv",
        "athens_weekends.csv",
        "barcelona_weekends.csv"
    )
)

load_city_airbnb_data <- function(path){

    extract_city <- function(path){
        strsplit(basename(path), "_")[[1]][1]
    }

    selected_cols <- c(
        "realSum",
        "cleanliness_rating",
        "person_capacity",
        "host_is_superhost",
        "guest_satisfaction_overall",
        "lng",
        "lat"
    )

    # Read the data and select columns
    airbnb_prices <- fread(path, select=selected_cols)
    airbnb_prices[ , city := extract_city(path)]
    airbnb_prices <- airbnb_prices[ 
        host_is_superhost == TRUE &
        cleanliness_rating >= 8 &
        person_capacity >= 3 &
        guest_satisfaction_overall >= 90
    ]
    airbnb_prices[, cleanliness_rating:=as.factor(cleanliness_rating)]
    

    return(airbnb_prices)
}



airbnb_all <- lapply(data_paths, load_city_airbnb_data) |>
    rbindlist()

# Subset per city 
n_accomodation_per_city <- 20
setkey(airbnb_all, city, realSum)
airbnb_topcity <- airbnb_all[, .SD[1:n_accomodation_per_city], by="city"]

expected_costs <- data.table(
    city = c("amsterdam", "athens", "barcelona"),
    flight_costs = c(50L, 150L, 100L),
    food_costs = c(50.5, 150L, 100L),
    attraction_costs = c(70L, 50L, 70L),
    cleanliness_costs = c(5L, 4L, 2L),
    total_cost = NA_integer_
)

# Debug following
# Additional cost for cleaning fees if cleanliness rating > 8
# Change function without changing factor type in original data
# Using as.numeric() messes things up - use as.numeric(as.character(...))

plot_with_prices <- function(airbnb, expected_costs=expected_costs, n_days=3){

    airbnb_costs <- merge(airbnb, expected_costs, by="city")
    airbnb_costs[, total_cost := realSum + flight_costs +
                   (food_costs + attraction_costs + (cleanliness_rating - 8) * cleanliness_costs) * n_days ]
    airbnb_costs[, cost_per_day := total_cost / n_days ]

    # subtite <- f(n_days)
    p <- ggplot(airbnb_costs, aes(x=lng, y=lat, color=cost_per_day, shape=city)) + 
    geom_point() +
    theme_bw() + 
    labs(
        x="Longitude",
        y="Latitude",
        color = "Cost per day",
        title="Cheapest 20 Airbnb per city",
        shape="City",
        subtitle = sprintf("For %s days stay", n_days)
    ) 
    return(p)
}

p <- plot_with_prices(airbnb_topcity, expected_costs, 3)
p <- plot_with_prices(airbnb_topcity, expected_costs, 0)
p <- plot_with_prices(airbnb_topcity, expected_costs)

lapply(c(0,3,5,7,14), plot_with_prices, airbnb=airbnb_topcity, expected_costs=expected_costs)
