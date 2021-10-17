library(tidyverse)

# Starbucks
starbucks_prices1 <- read_csv("starbucks_prices.csv")
starbucks_prices2 <- read_csv("starbucks_prices2.csv")
starbucks_prices <- full_join(starbucks_prices1, starbucks_prices2)

starbucks_nutrition <- read_csv("starbucks_full.csv")

names(starbucks_prices) <- c("NAME", "SIZE", "CALS", "PRICE")

starbucks_joined <- left_join(
    starbucks_nutrition,
    starbucks_prices
)

caffeine_mg <- 
    as.numeric(str_split_fixed(starbucks_joined$CAFFEINE_mg, "[-+]", n=2)[, 1])

starbucks_join <- starbucks_joined %>% na_if("NA") %>%
    mutate(CAFFEINE_mg = caffeine_mg) %>%
    mutate(CPD = CAFFEINE_mg / PRICE)

write_csv(starbucks_join, "complete_data/starbucks.csv")

# Dunkin Donuts
dunkin_prices <- read_csv("dunkin-prices.csv")
dunkin_full <- read_csv("dunkin_full.csv")

dunkin_prices <- dunkin_prices %>% 
    mutate(PRICE = as.numeric(gsub("\\$", "", PRICE))) %>%
    mutate(CALS = as.numeric(gsub("Cal", "", CALS))) %>%
    drop_na()

write_csv(dunkin_prices, "dunkin-prices.csv")

dunkin_joined <- left_join(dunkin_full, dunkin_prices, by="NAME")

dunkin_joined %>% 
    mutate(CPD = CAFFEINE_mg / PRICE) %>% drop_na(PRICE) %>%
    write_csv("complete_data/dunkin.csv")

# McDonalds
mcd_prices <- read_csv("mcdonalds_prices.csv")
mcd_full   <- read_csv("mcdonalds_full.csv")

mcd_join <- left_join(mcd_full, mcd_prices, by="NAME") %>%
    mutate(CPD = CAFFEINE_mg / PRICE) %>% drop_na(PRICE) %>%
    write_csv("complete_data/mcdonalds.csv")

View(mcd_join %>% drop_na(PRICE))
