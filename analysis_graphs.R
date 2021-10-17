library(tidyverse)
library(gridExtra)

dataset = read.csv("complete_data/restaurants.csv")
caffeine_cost_violin = ggplot(dataset) + geom_violin(aes(x = RESTAURANT, y = CPD, color = RESTAURANT)) + labs(x = "Restaurant", y = "Caffeine per Dollar") + theme(legend.position = "none")

cost_milk_cal = ggplot(dataset) + geom_point(aes(x = CALORIES, y = PRICE, color = MILK), position = "jitter")

milk_calories = ggplot(dataset) + geom_violin(aes(x = MILK, y = CALORIES))
milk_cost = ggplot(dataset) + geom_violin(aes(x = MILK, y = PRICE))

caffeine_restaurant = ggplot(dataset) + geom_violin(aes(x = RESTAURANT, y = CAFFEINE_mg, color = RESTAURANT)) + labs(x = "Restaurant", y = "Caffeine") + theme(legend.position = "none")
calories_restaurant = ggplot(dataset) + geom_violin(aes(x = RESTAURANT, y = CALORIES, color = RESTAURANT)) + labs(x = "Restaurant", y = "Calories") + theme(legend.position = "none")
cost_restaurant = ggplot(dataset) + geom_violin(aes(x = RESTAURANT, y = PRICE, color = RESTAURANT)) + labs(x = "Restaurant", y = "Price") + theme(legend.position = "none")

grid.arrange(caffeine_cost_violin, caffeine_restaurant, calories_restaurant, cost_restaurant, nrow = 2)
