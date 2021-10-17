library(tidyverse)


starbucks_prices <- read_csv("starbucks_prices.csv")
starbucks_nutrition <- read_csv("starbucks_full.csv")

names(starbucks_prices) <- c("NAME", "SIZE", "CALS", "PRICE")

starbucks_joined <- left_join(
    starbucks_nutrition,
    starbucks_prices
)

View(starbucks_joined[, c("NAME", "SIZE", "CALS", "PRICE")])
