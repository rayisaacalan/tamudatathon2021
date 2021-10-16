library(tidyverse)
library(rvest)

dunkin = read.csv("dunkin_no_caffeine.csv", na.strings = "NA")
colnames(dunkin)[1] = "NAME"

milkType = function(name) {
  if(str_detect(name, "Whole Milk")) {
    return("Whole")
  } else if(str_detect(name, "Skim Milk")) {
    return("Nonfat")
  } else if(str_detect(name, "AlmondMilk")) {
    return("Almond")
  } else if(str_detect(name, "with Cream")) {
    return("Cream")
  } else {
    return(NA)
  }
}

removeSize = function(name) {
  newName = strsplit(name, "-")[[1]][1]
  return(newName)
}

dunkin$NAME = sapply(dunkin$NAME, removeSize) # Clean up the name a bit
dunkin$MILK = sapply(dunkin$NAME, milkType) # Determine milk factor by the name of the drink
CAFFEINE_mg = rep(NA, length(dunkin$NAME))
dunkin = cbind(dunkin, CAFFEINE_mg)
write.csv(dunkin, "dunkin_no_caffeine_clean.csv")

caffeine_url = "https://www.caffeineinformer.com/complete-guide-to-dunkin-donuts-caffeine-content"
caffeine_html = read_html(caffeine_url)

dunkin_caffeine = html_element(caffeine_html, ".datatable , th") %>% html_table() # get the caffeine data table out of the HTML
colnames(dunkin_caffeine) = c("NAME", "Small", "Medium", "Large", "Xlarge") # rename sizes to match factors of existing Dunkin nutrition data
dunkin_caffeine[1:2,1] = c("Coffee", "Decaf Coffee")
dunkin_caffeine = dunkin_caffeine %>% slice(1:31) # don't include bottled drinks, only fresh
dunkin_caffeine = dunkin_caffeine %>% pivot_longer(cols = 2:5, names_to = "SIZE", values_to = "CAFFEINE_mg") # rename columns to be consistent
dunkin_caffeine$CAFFEINE_mg = as.numeric(sub("\\D*(\\d+).*", "\\1", dunkin_caffeine$CAFFEINE_mg)) # strip out only caffeine mg number, remove unit
dunkin_caffeine = dunkin_caffeine %>% filter(!is.na(CAFFEINE_mg)) # remove invalid drink size combos

determineCaffeine = function(drink, dictionary) {
  if(str_detect(drink[[1]], dictionary[[1]]) & (drink[[2]] == dictionary[[2]])) {
    return(dictionary[[3]])
  } else {
    return(NA)
  }
}

for(i in 1:length(dunkin$NAME)) { # Brute force solution since I'm only doing this once
  for(j in 1:length(dunkin_caffeine$NAME)) { # Check every drink against every known caffeine quantity
    result = determineCaffeine(dunkin[i,], as.data.frame(dunkin_caffeine[j,]))
    if(!is.na(result)) {
      dunkin$CAFFEINE_mg[i] = result
    }
  }
}

dunkin[330:331,18] = 118 # Correct for nonstandard size for espresso shot
dunkin = dunkin %>% filter(!is.na(CAFFEINE_mg)) # Consider only 'normal' drinks (with full info)



