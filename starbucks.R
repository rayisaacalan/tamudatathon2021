library(tidyverse)

starbucks = read.csv("starbucks_full.csv", na.strings = "NA")
starbucks$CAFFEINE_mg = as.numeric(sub("\\D*(\\d+).*", "\\1", starbucks$CAFFEINE_mg))
