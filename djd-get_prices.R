# Caffeine concentration for coffee

library(tidyverse)
library(rvest)

url <- c(
    "https://www.fastfoodprice.com/menus/starbucks-prices/",
    "https://www.fastfoodprice.com/menu/dunkin-donuts-prices/",
    "https://www.fastfoodprice.com/menu/mcdonalds-prices/",
    "https://nutrition-charts.com/mcdonalds-nutrition-facts-calorie-information/",
    "https://getmenuprices.com/starbucks/"
)

get_table <- function(url){
    read_url <- read_html(url) 
    new_table <- html_table(read_url, fill=T)[[3]]
    names(new_table) <- c("NAME", "SIZE", "CALS", "PRICE")
    return(new_table)
}

expand_size <- function(size){
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

modify_cals <- function(string){
    as.numeric(str_split_fixed(string, "[-C]", n=2)[, 1])
}

starbucks <- url[1] %>% get_table %>%
    mutate(cals, cals = as.numeric(gsub("Cal", "", cals))) %>%
    mutate(price, price = as.numeric(gsub("\\$", "", price))) %>%
    drop_na() %>%
    arrange(menu_item)

write_csv(starbucks, "starbucks_prices.csv")

dunkin_tables <- url[2] %>% read_html() %>% html_table()

dunkin <- dunkin_tables[[2]]

for(t in 3:6){
    dunkin <- add_row(dunkin, dunkin_tables[[t]])
}

names(dunkin) <- c("NAME", "SIZE", "CALS", "PRICE")

dunkin <- dunkin %>% 
    mutate(cals, cals=modify_cals(cals)) %>%
    mutate(price, price = as.numeric(gsub("\\$", "", price))) %>%
    mutate(size, size = expand_size(size)) %>%
    drop_na() %>%
    arrange(menu_item)

write_csv(dunkin, "dunkin-prices.csv")

starbucks2 <- url[5] %>% read_html()

starbucks2_prices <- (starbucks2 %>% html_table())[[1]]

names(starbucks2_prices) <- c("NAME", "SIZE", "PRICE")

starbucks2_prices[-1, ] %>% 
    mutate(PRICE = as.numeric(gsub("\\$", "", PRICE))) %>% 
    write_csv("starbucks_prices2.csv")
