library(data.table)
library(ggplot2)
library(here)

repo_path <- here()
data_dir <- file.path(repo_path, "session2/data")

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
        "room_type",
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
    airbnb_prices[, room_type:=as.factor(room_type)]
    # Fix 1: Conversion to factor messes up operations later...
    # airbnb_prices[, cleanliness_rating:=as.factor(cleanliness_rating)]
    

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

plot_with_prices <- function(airbnb, expected_costs=expected_costs, n_days=3){

    costs <- merge(airbnb, expected_costs, by="city")
    costs[, total_cost := realSum + flight_costs +
                   (food_costs + attraction_costs + (cleanliness_rating - 8) * cleanliness_costs) * n_days ]
    costs[, cost_per_day := total_cost / n_days ]
    
    # Fix 2: Target variable should be total_cost, not costs
    airbnb_lm <- lm(total_cost ~ room_type + cleanliness_rating + host_is_superhost + city +
                      guest_satisfaction_overall, data = costs)
    summary_lm <- summary(airbnb_lm)
    p_vals <- summary_lm$coefficients[, 4]
    print(p_vals)
    
    p <- ggplot(costs, aes(x=lng, y=lat, color=cost_per_day, shape=city)) + 
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