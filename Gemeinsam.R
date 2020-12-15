rm(list = ls())

setwd("C:/Users/JUAN DIEGO/Downloads/U/Memoria/Gemeinsam")

library(readxl)
library(dplyr)
library(plm)
library(lmtest)
library(stargazer)
library(tidyr)

RCTratio <- read.csv("C:/Users/JUAN DIEGO/Downloads/U/Memoria/RCTS/RATIORCTS2.csv")

BEvo     <- read.csv("C:/Users/JUAN DIEGO/Downloads/U/Memoria/Bew/Bevolkerung2.csv")

AUSbi    <- read.csv("C:/Users/JUAN DIEGO/Downloads/U/Memoria/AUSBILDUNG/Ausbildung.csv")
  
ETat     <- read.csv("C:/Users/JUAN DIEGO/Downloads/U/Memoria/ETAT/ETAT.csv")

TAMsat   <- read.csv("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/RSHAPE/Orkan.csv")

GCP      <- read.csv("C:/Users/JUAN DIEGO/Downloads/U/Memoria/GCP/GCP.csv")

### ELiminar "total" y "kenya" todo 47 obs 

AUSbi <- AUSbi[-42,]
BEvo  <- BEvo[-12,]
ETat  <- ETat[-48,]
GCP   <- GCP[,-1]

# Estudiantes cada 10000 habitantes

AUSbi <- AUSbi[,-1]/BEvo[,4:9]
COUNTY <- ETat$COUNTY
ETat  <- ETat[,-6]/BEvo[,5:9]
ETat  <- ETat*1000
ETat$COUNTY <- COUNTY
AUSbi <- AUSbi*1000

(47580+253779)/849197.6
#Organizar Tamsat 

TAMsat <- TAMsat[order(TAMsat$COUNTY),]

#Unificar las llaves county 
RCTratio$COUNTY  <- ETat$COUNTY
BEvo$COUNTY      <- ETat$COUNTY
AUSbi$Category   <- ETat$COUNTY
TAMsat$COUNTY    <- ETat$COUNTY
GCP$County       <- ETat$COUNTY

###Unificar nombres 
names(AUSbi) <- c("X2012","X2013","X2014","X2015","X2016","X2017","COUNTY")
names(GCP) <- c("COUNTY", "X2013","X2014","X2015","X2016","X2017")

##dividr tamsat en dos 
TAMsatT <- TAMsat[,-c(7:11)]
TAMsatD <- TAMsat[,-c(1:6)]
names(TAMsatT) <- c( "X2012","X2013","X2014","X2015","X2016","X2017","COUNTY")
names(TAMsatD) <- c( "X2013","X2014","X2015","X2016","X2017","COUNTY")


#Convertir bases a panel 
RCTratioP <- pivot_longer(RCTratio,
                        col = c("X2013","X2014","X2015","X2016","X2017"),
                        names_to = "Año",
                        values_to = "Ratio",
                        values_drop_na = TRUE) #colnames(RCTratio)

BEvoP <- pivot_longer(BEvo,
                          col = c("X2009","X2010","X2011","X2012", "X2013","X2014","X2015","X2016","X2017","X2018","X2019"),
                          names_to = "Año",
                          values_to = "BEvo",
                          values_drop_na = TRUE) #colnames(BEvo)

AUSbiP <- pivot_longer(AUSbi,
                      col = c("X2012","X2013","X2014","X2015","X2016", "X2017"),
                      names_to = "Año",
                      values_to = "AUSbi",
                      values_drop_na = TRUE) #colnames(BEvo)

TAMsatTP <- pivot_longer(TAMsatT,
                       col = c("X2012","X2013","X2014","X2015","X2016","X2017"),
                       names_to = "Año",
                       values_to = "TAMsatT",
                       values_drop_na = TRUE) #colnames(BEvo)

TAMsatDP <- pivot_longer(TAMsatD,
                         col = c("X2013","X2014","X2015","X2016","X2017"),
                         names_to = "Año",
                         values_to = "TAMsatD",
                         values_drop_na = TRUE) #colnames(BEvo)


ETatP <- pivot_longer(ETat,
                         col = c("X2013","X2014","X2015","X2016","X2017"),
                         names_to = "Año",
                         values_to = "ETat",
                         values_drop_na = TRUE) #colnames(BEvo)

GCPP <- pivot_longer(GCP,
                      col = c("X2013","X2014","X2015","X2016","X2017"),
                      names_to = "Año",
                      values_to = "GCP",
                      values_drop_na = TRUE) #colnames(BEvo)
### UNIR los paneles

Famiprobezirk=merge(x = RCTratioP, y = BEvoP , by=c("COUNTY", "Año"), all.y = TRUE)
Famiprobezirk1=merge(x = Famiprobezirk, y = AUSbiP , by=c("COUNTY", "Año"), all.y = TRUE)
Famiprobezirk2=merge(x = Famiprobezirk1, y = TAMsatTP , by=c("COUNTY", "Año"), all.y = TRUE)
Famiprobezirk3=merge(x = Famiprobezirk2, y = TAMsatDP , by=c("COUNTY", "Año"), all.y = TRUE)
Famiprobezirk4=merge(x = Famiprobezirk3, y = ETatP , by=c("COUNTY", "Año"), all.y = TRUE)

###LISTO!!! PERO ME FALTÖ BID POR KOPF

GCP = read_excel("C:/Users/JUAN DIEGO/Downloads/U/Antes/9/Pobreza y desarrollo/Entrega Final/gcp.xlsx")
GCP <- GCP[-c(48,49,50),]
GCP <- GCP[order(GCP$County),]
GCP$COUNTY <- ETat$COUNTY
GCP <- GCP[,-c(1,2)]
names(GCP) <- c( "X2013","X2014","X2015","X2016","X2017","COUNTY")

GCP$`X2013` = as.numeric(GCP$`X2013`)
GCP$`X2014` = as.numeric(GCP$`X2014`)
GCP$`X2015` = as.numeric(GCP$`X2015`)
GCP$`X2016` = as.numeric(GCP$`X2016`)
GCP$`X2017` = as.numeric(GCP$`X2017`)
GCP$`X2018` = as.numeric(GCP$`X2019`)

GCPKOPF <- GCP[,-6]/BEvo[,5:9] #PERFECTO
GCPKOPF$COUNTY <- ETat$COUNTY

GCPKOPFP <- pivot_longer(GCPKOPF,
                      col = c("X2013","X2014","X2015","X2016","X2017"),
                      names_to = "Año",
                      values_to = "GCPKOPF",
                      values_drop_na = TRUE) #colnames(BEvo)

###AHORA SÏ

Famiprobezirk5=merge(x = Famiprobezirk4, y = GCPP , by=c("COUNTY", "Año"), all.y = TRUE)

###EFEcTOS FIJOS
Famiprobezirkque <- Famiprobezirk5 %>% ungroup()
Famiprobezirkque$Año <- as.factor(Famiprobezirkque$Año)

fijos <- plm(GCP ~ Ratio  + AUSbi + ETat + TAMsatT + TAMsatD ,
            data = Famiprobezirkque,
            index = c("COUNTY", "Año"), 
            model = "within", effect = "twoways")

fijost <- coeftest(fijos, vcov. = vcovHC, type = "HC1")

summary(fijos)

colnames(Famiprobezirkque) #c(Ratio, BEvo , AUSbi, TAMSatT, TAMSatT, ETat) 

## Sólo Western Kenya y Nyanza

FamiprobezirkProvinz <- Famiprobezirkque[c(11:20, 36:40, 51:55, 76:85, 131:135, 166:170, 186:190, 221:225),]
# Bungoma, Busia, Homa bay, Kakamega, Kissi, Kisumu, Migori, Nyamira, Siaya, Vihiga. 

fijosProvinzx  <- plm(GCP ~ Ratio + AUSbi + ETat + TAMsatT + TAMsatD,
                   data = FamiprobezirkProvinz,
                   index = c("COUNTY", "Año"), 
                   model = "within", effect = "twoways")

fijosProvinzTb <- coeftest(fijosProvinzb, vcov. = vcovHC, type = "HC1")

summary(fijosProvinz)
sd(FamiprobezirkProvinz$GCP)
### Stargazer

stargazer( fijostz, fijostc, fijostv, fijostb , fijost ,title="Results", align=TRUE)
