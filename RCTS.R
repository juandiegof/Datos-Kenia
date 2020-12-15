rm(list=rm())

setwd("C:/Users/JUAN DIEGO/Downloads/U/Memoria/RCTS")

library(readxl)
library(dplyr)

rcts = read_excel("bezirk.xlsx")
hogares = read_excel("Householdsize.xlsx")
hogares = hogares[-c(95,96,97),]

bevo = read.csv("C:/Users/JUAN DIEGO/Downloads/U/Memoria/Bew/BEvOLKERUNG2.csv")
bevo = bevo[-12,]
#newrow <- bevo[1,]
#bevo <- rbind(bevo[1:30,],newrow,bevo[-(1:30),]) ## meter a Nairobi donde es
#bevo = bevo[-1,]

# necesito hogares totales por año 
# 1 añadir columna hogares de bevo, dividir eso entre pob total. 
# 2 juntar fami con bevo y dividir por columna de hogar por año.

toDelete <- seq(1, nrow(hogares), 2)
toDelete

totalh <- hogares[-c(toDelete) ,]
totalh <- totalh[-48 ,]
totalh <- totalh[order(totalh$`County Name`),]

toKeep <- seq(2, nrow(hogares), 2)
Durchschnitt <- hogares[-c(toKeep) ,]


averagesizeh = bevo$X2019/totalh$`2019`

seriehogares = bevo[,-c(12)]/averagesizeh

seriehogares #perfecto

ratiorcts =  rcts[,-1]/seriehogares[,-c(1,2,3,4,10,11,12)]

### ahora con el acumulado de rcts

#rcts[, 2] <-
rcts1 = t(rcts[,-1])

rcts1= as.data.frame(rcts1)
cumrcts = t(cumsum(rcts1))
cumrcts <- as.data.frame(cumrcts)

### radio cumrcts sobre hogares

RATIORCTS =  cumrcts/seriehogares[,-c(1,2,3,4,10,11,12)]
RATIORCTS$COUNTY = bevo$COUNTY

write.csv(RATIORCTS, "RATIORCTS2.csv", row.names = FALSE)

was <- read.csv("RATIORCTS2.CSV")

