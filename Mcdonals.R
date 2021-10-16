# Caffeine concentration for coffee

library(tidyverse)
library(rvest)

url <- c("https://nutrition-charts.com/mcdonalds-nutrition-facts-calorie-information/")
get_table <- function(url){
    read_url <- read_html(url) 
    new_table <- html_table(read_url, fill=T)
    #names(new_table) <- c("menu_item", "SIZE", "cals", "price")
    return(new_table)
}
a=get_table(url)




b=a[[9]]
b=b[-c(8,9),]
names(b)[1] = c("NAME")

for(t in 10:12){
    names(a[[t]])[1] = c("NAME")
    b=add_row(b,a[[t]])
    
}

b$MILK <- "Value"
MILKType = function(name) {
    if(str_detect(name, "Low fat")) {
        return("Low fat")
    } else if(str_detect(name, "Nonfat")) {
        return("Nonfat")
    } else if(str_detect(name, "Shake")) {
        return("cream")
    } else if(str_detect(name, "Cappuccino")) {
        return("Whole")
    }else if(str_detect(name, "Latte")) {
        return("Whole")}
    else if(str_detect(name, "Mocha")) {
        return("Whole")}
    else if(str_detect(name, "Hot Chocolate")) {
        return("Whole")}
    else if(str_detect(name, "Frappe")) {
        return("Whole")}
    else if(str_detect(name, "Smoothie")) {
        return("Reduced fat")}
    
    else {
        return(NA)
    }
}

b$SIZE <- "Value"
for (i in 1: length(b$NAME)){
    if(str_detect(b$NAME[i], "Small")) {
        b$SIZE[i] <- "Small"
    }
    if(str_detect(b$NAME[i], "Medium")) {
        b$SIZE[i] <- "Mediun"
    }
    if(str_detect(b$NAME[i], "Large")) {
        b$SIZE[i] <- "Large"
    }
    if(str_detect(b$NAME[i], "Large")) {
        b$SIZE[i] <- "Large"
    }
    if(str_detect(b$NAME[i], "21")) {
        b$SIZE[i] <- "21 oz"
    }
    if(str_detect(b$NAME[i], "12")) {
        b$SIZE[i] <- "12 oz"
    }
    if(str_detect(b$NAME[i], "16")) {
        b$SIZE[i] <- "16 oz"
    }
    if(str_detect(b$NAME[i], "32")) {
        b$SIZE[i] <- "32 oz"
    }
    if(str_detect(b$NAME[i], "22")) {
        b$SIZE[i] <- "22 oz"
    }
    
} 
    
    

for (i in 1: length((b$NAME))){
    

b$MILK[i] <- MILKType(b$NAME[i])
}



for (i in 1: length((b$NAME))){
    
    
    b$NAME[i] <- str_split(b$NAME[i],"\\(")[[1]][1]
}
names(b)[names(b) == 'Calories'] <- "CALORIES"
names(b)[names(b) == 'Total Fat (g)'] <- "TOTAL_FAT_g"
names(b)[names(b) == 'Saturated Fat (g)'] <- "SATURATED_FAT_g"
names(b)[names(b) == 'Trans Fat (g)'] <- "TRANS_FAT_g"
names(b)[names(b) == 'Cholesterol (mg)'] <- "CHOLESTEROL_mg"
names(b)[names(b) == 'Sodium (mg)'] <- "SODIUM_mg"
names(b)[names(b) == 'Carbs (g)'] <- "TOTAL_CARB_g"
names(b)[names(b) == 'Fiber (g)'] <- "DIETARY_FIBER_g"
names(b)[names(b) == 'Sugars (g)'] <- "SUGAR_g"
names(b)[names(b) == 'Protein (g)'] <- "PROTEIN_g"
drop <- c("Calories from Fat","Weight Watchers Pnts")
b = b[,!(names(b) %in% drop)]
b<- b[, c(1, 13, 12, 2, 3,4,5,6,7,8,9,10,11)]

write_csv(b,"mcdonald_nutrition.csv")

