library(tidyverse)
library(rvest)

mcdonalds_caffeine_url = "https://www.caffeineinformer.com/mccafe-coffee-caffeine-content"
mcd_caffeine_html = read_html(mcdonalds_caffeine_url)

mcd_caffeine = html_element(mcd_caffeine_html, ".datatable , th") %>% html_table() # get the caffeine data table out of the HTML
colnames(mcd_caffeine) = c("NAME", "Small", "Medium", "Large") # rename sizes to match factors of existing McD nutrition data
mcd_caffeine = mcd_caffeine[,-5] # XLarge not a valid size in general
mcd_caffeine[c(1:2,17),1] = c("Coffee", "Decaf Coffee", "Frappe")
mcd_caffeine = mcd_caffeine %>% pivot_longer(cols = 2:4, names_to = "SIZE", values_to = "CAFFEINE_mg") # rename columns to be consistent
mcd_caffeine$CAFFEINE_mg = as.numeric(sub("\\D*(\\d+).*", "\\1", mcd_caffeine$CAFFEINE_mg)) # strip out only caffeine mg number, remove unit
mcd_caffeine = mcd_caffeine %>% filter(!is.na(CAFFEINE_mg)) # remove invalid drink size combos

source("McDonalds's_nutrition.R")
mcdonalds = read.csv("mcdonald_nutrition.csv")
CAFFEINE_mg = rep(NA, length(mcdonalds$NAME))
mcdonalds = cbind(mcdonalds, CAFFEINE_mg)


determineCaffeine = function(drink, dictionary) {
  if(str_detect(drink[[1]], dictionary[[1]]) & (drink[[2]] == dictionary[[2]])) {
    return(dictionary[[3]])
  } else {
    return(NA)
  }
}

for(i in 1:length(mcdonalds$NAME)) { # Brute force solution since I'm only doing this once
  for(j in 1:length(mcd_caffeine$NAME)) { # Check every drink against every known caffeine quantity
    result = determineCaffeine(mcdonalds[i,], as.data.frame(mcd_caffeine[j,]))
    if(!is.na(result)) {
      mcdonalds$CAFFEINE_mg[i] = result
    }
  }
}

mcdonalds = mcdonalds %>% filter(!is.na(CAFFEINE_mg)) # Consider only 'normal' drinks (with full info)
write.csv(mcdonalds, "mcdonalds_full.csv")
