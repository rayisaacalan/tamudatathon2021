library(tidyverse)

dunkin <- read_csv("complete_data/dunkin.csv")
starbucks <- read_csv("complete_data/starbucks.csv")
mcd <- read_csv("complete_data/mcdonalds.csv")

add_row(dunkin, starbucks)

columns <- intersect(
    intersect(names(dunkin), names(starbucks)),
    names(mcd)
)

dunkin <- dunkin %>% select(columns)
starbucks <- starbucks %>% select(columns)
mcd <- mcd %>% select(columns)

dunkin["RESTAURANT"] <- "Dunkin"
starbucks["RESTAURANT"] <- "Starbucks"
mcd["RESTAURANT"] <- "McDonalds"

merged_data <- add_row(add_row(dunkin, starbucks), mcd) %>% drop_na(CPD)
dim(merged_data)

write_csv(merged_data, "complete_data/restaurants.csv")

max_caffeine <- which.max(merged_data$CPD)
merged_data[max_caffeine, c("NAME", "SIZE", "CAFFEINE_mg", "PRICE", "CPD", "RESTAURANT")]
