rm(list=rm())

setwd("C:/Users/JUAN DIEGO/Downloads/U/Memoria/AUSBILDUNG")

library(readxl)
library(janitor)
library(dplyr)
library(plyr)

Grund = read_excel("Statistical Abstract 2019-seiten-280.xlsx")
höhere =  read_excel("Statistical Abstract 2019-seiten-282.xlsx")

Grund <- Grund %>%
  row_to_names(row_number = 3)
höhere <- höhere %>%
  row_to_names(row_number = 3)

Grund <-Grund[complete.cases(Grund), ]
höhere <-höhere[complete.cases(höhere), ]
Grund$County <- höhere$COUNTY

names(Grund) <- c("COUNTY", "2012", "2013", "2014", "2015", "2016", "2017", "2018")
names(höhere) <- c("COUNTY", "2012", "2013", "2014", "2015", "2016", "2017", "2018")

höhere$`2012` = as.numeric(höhere$`2012`)
höhere$`2013` = as.numeric(höhere$`2013`)
höhere$`2014` = as.numeric(höhere$`2014`)
höhere$`2015` = as.numeric(höhere$`2015`)
höhere$`2016` = as.numeric(höhere$`2016`)
höhere$`2017` = as.numeric(höhere$`2017`)
höhere$`2018` = as.numeric(höhere$`2019`)
Grund$`2012` = as.numeric(Grund$`2012`)
Grund$`2013` = as.numeric(Grund$`2013`)
Grund$`2014` = as.numeric(Grund$`2014`)
Grund$`2015` = as.numeric(Grund$`2015`)
Grund$`2016` = as.numeric(Grund$`2016`)
Grund$`2017` = as.numeric(Grund$`2017`)
Grund$`2018` = as.numeric(Grund$`2018`)

#plus <- bind_rows(Grund[,-1] %>% add_rownames(), 
#         höhere[,-1] %>% add_rownames()) %>% 
  # evaluate following calls for each value in the rowname column
#  group_by(rowname) %>% 
  # add all non-grouping variables
#  summarise_all(sum)

# 144484+28804 (31,2014, Perfekt)
all_data <- rbind.fill(Grund,höhere)
all_data <- aggregate(cbind(all_data$"2012", all_data$"2013", all_data$"2014", all_data$"2015",all_data$"2016",all_data$"2017"),
                      by=list(Category=all_data$COUNTY), FUN=sum)

write.csv(all_data, "Ausbildung.csv", row.names = FALSE)

was= read.csv("Ausbildung.csv")
