rm(list=ls())
setwd("C:/Users/JUAN DIEGO/Downloads/U/Memoria/ETAT")

library(readxl)
library(janitor)

et13 = read_excel("STATISTICAL-ABSTRACT-2014-seiten-241.xlsx")
et14 = read_excel("TheCountyAllocationofRevenueBill,2014-seiten-7-8.xlsx")
et15 = read_excel("KENYA-STATISTICAL-ABSTRACT-2016-seiten-163.xlsx")
et1617 = read_excel("Statistical-Abstract-2018-seiten-112.xlsx")

et13 <- et13 %>%
  row_to_names(row_number = 4)
et14 <- et14 %>%
  row_to_names(row_number = 7)
et15 <- et15 %>%
  row_to_names(row_number = 3)
et1617 <- et1617 %>%
  row_to_names(row_number = 4)

#et13 <-et13[complete.cases(et13), ]
#et14 <-et14[complete.cases(et14), ]
#et15 <-et15[complete.cases(et15), ]
#et1617 <-et1617[complete.cases(et1617), ]

### Dejar solo los 47 counties

et13 <-et13[1:48,]
et14 <-et14[1:48,]
et15 <-et15[1:48,]
et1617 <-et1617[1:48,]

### crear dataframe

casiet = as.data.frame(et13$`Total Revenue`)
casiet <- cbind(casiet, et14[,5], et15$`Total Budget`, et1617[,8], et1617[,9], et13$COUNTY)

names(casiet) <- c("2013", "2014", "2015", "2016", "2017", "COUNTY")

casiet$`2013`= as.numeric(as.character(casiet$`2013`))
casiet$`2014`=as.numeric(as.character(casiet$`2014`))
casiet$`2015`=as.numeric(as.character(casiet$`2015`))
casiet$`2015`=as.numeric(as.character(casiet$`2015`))
casiet$`2017`=as.numeric(as.character(casiet$`2017`))

casiet[,2] <- casiet[,2]/1000000

write.csv(casiet, "ETAT.csv", row.names = FALSE)

was = read.csv("ETAT.csv")
#                           --++--