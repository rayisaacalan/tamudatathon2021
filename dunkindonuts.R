library(tidyverse)
library(tabulizer)

pages = 22:54
area = locate_areas("dunkin_full.pdf", pages)
dunkin_table = extract_tables("dunkin_full.pdf",
                              pages = pages,
                              area = area)
