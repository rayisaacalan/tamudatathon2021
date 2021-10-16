# Caffeine concentration for coffee

library(tidyverse)
library(rvest)

url <- c(
    "https://www.fastfoodprice.com/menus/starbucks-prices/",
    "https://www.fastfoodprice.com/menu/dunkin-donuts-prices/",
    "https://www.fastfoodprice.com/menu/mcdonalds-prices/",
    "https://nutrition-charts.com/mcdonalds-nutrition-facts-calorie-information/"
)

get_table <- function(url){
    read_url <- read_html(url) 
    new_table <- html_table(read_url, fill=T)[[3]]
    names(new_table) <- c("menu_item", "size", "cals", "price")
    return(new_table)
}

size_to_volume <- function(size){
    if(size == "S"){
        return("Small")
    }else if(size == "M"){
        return("Medium")
    }else if("L"){
        return("Large")
    }else if("XL"){
        return("XLarge")
    }
}

url[1] %>% get_table %>%
    mutate(cals, cals = as.numeric(gsub("Cal", "", cals))) %>%
    mutate(price, price = as.numeric(gsub("\\$", "", price))) %>%
    drop_na() %>%
    write_csv("starbucks_prices.csv")

url[2] %>% get_table %>% 
