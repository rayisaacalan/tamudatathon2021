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

dunkin$MILK = sapply(dunkin$NAME, milkType)
write.csv(dunkin, "dunkin_no_caffeine_clean.csv")

caffeine_url = "https://www.caffeineinformer.com/complete-guide-to-dunkin-donuts-caffeine-content"
caffeine_html = read_html(caffeine_url)

dunkin_caffeine = html_element(caffeine_html, ".datatable , th") %>% html_table()
