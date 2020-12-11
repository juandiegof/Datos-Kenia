rm(list=ls())
setwd("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/RSHAPE")

library(rgdal)
library(ncdf4)
library(raster)
library(dplyr)

shp = readOGR("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/kenyan-counties/County.shp")
reg = nc_open("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/docediecisiete.nc")

reg1.brick = brick("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/docediecisiete.nc")

extent(reg1.brick)

crs(shp)

crs(reg1.brick) 

#MAGIE

reg1.mask = mask(reg1.brick, shp)

### VERSCHENEIDEN PRO JAHR 


reg1.mask12=reg1.mask[[1:365,]]
reg1.mask13=reg1.mask[[365:730,]]
reg1.mask14=reg1.mask[[730:1095,]]
reg1.mask15=reg1.mask[[1095:1460,]]
reg1.mask16=reg1.mask[[1460:1825,]]
reg1.mask17=reg1.mask[[1825:2190,]]

###VERSCHENEIDEN PRO COUNTY
##DOCE
kis_stk12 = stack(reg1.mask12)

rgdal::readOGR("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/kenyan-counties/County.shp", stringsAsFactors = F) %>%
  sp::spTransform(CRS(projection(kis_stk12[[1]]))) -> basin12

DOCE = vector(mode = "character", length = 47)
for (i in 1:47){
  DOCE[i] =  sum(extract(kis_stk12, spPolygons(basin12[i,]), fun= mean, na.rm= TRUE), na.rm= TRUE)
}

##TRECE
kis_stk13 = stack(reg1.mask13)

rgdal::readOGR("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/kenyan-counties/County.shp", stringsAsFactors = F) %>%
  sp::spTransform(CRS(projection(kis_stk13[[1]]))) -> basin13

TRECE = vector(mode = "character", length = 47)
for (i in 1:47){
  TRECE[i] =  sum(extract(kis_stk13, spPolygons(basin13[i,]), fun= mean, na.rm= TRUE))
}

##CATORCE
kis_stk14 = stack(reg1.mask14)

rgdal::readOGR("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/kenyan-counties/County.shp", stringsAsFactors = F) %>%
  sp::spTransform(CRS(projection(kis_stk14[[1]]))) -> basin14

CATORCE = vector(mode = "character", length = 47)
for (i in 1:47){
  CATORCE[i] =  sum(extract(kis_stk14, spPolygons(basin14[i,]), fun= mean, na.rm= TRUE), na.rm= TRUE)
}

##QUINCE
kis_stk15 = stack(reg1.mask15)

rgdal::readOGR("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/kenyan-counties/County.shp", stringsAsFactors = F) %>%
  sp::spTransform(CRS(projection(kis_stk15[[1]]))) -> basin15

QUINCE = vector(mode = "character", length = 47)
for (i in 1:47){
  QUINCE[i] =  sum(extract(kis_stk15, spPolygons(basin15[i,]), fun= mean, na.rm= TRUE))
}

##DIECISEIS
kis_stk16 = stack(reg1.mask16)

rgdal::readOGR("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/kenyan-counties/County.shp", stringsAsFactors = F) %>%
  sp::spTransform(CRS(projection(kis_stk16[[1]]))) -> basin16

DIECISEIS = vector(mode = "character", length = 47)
for (i in 1:47){
  DIECISEIS[i] =  sum(extract(kis_stk16, spPolygons(basin16[i,]), fun= mean, na.rm= TRUE))
}

##DIECISIETE
kis_stk17 = stack(reg1.mask17)

rgdal::readOGR("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/kenyan-counties/County.shp", stringsAsFactors = F) %>%
  sp::spTransform(CRS(projection(kis_stk17[[1]]))) -> basin17

DIECISIETE = vector(mode = "character", length = 47)
for (i in 1:47){
  DIECISIETE[i] =  sum(extract(kis_stk17, spPolygons(basin17[i,]), fun= mean, na.rm= TRUE), na.rm= TRUE)
}

#### DATAFRAME ANBAUEN


Orkan = data.frame(DOCE,TRECE,CATORCE,QUINCE,DIECISEIS,DIECISIETE)
names(Orkan) <- c(DOCE,TRECE,CATORCE,QUINCE,DIECISEIS,DIECISIETE)

write.csv(Orkan,"C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/RSHAPE/Orkan.csv", row.names = FALSE)

### UNTERSCHIEDE

Orkan.csv = read.csv("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/RSHAPE/Orkan.csv")


Orkan.dif <- cbind(Orkan.csv, t(apply(Orkan.csv, 1, diff)))
Counties=basin12$COUNTY
Orkan.dif<- cbind(Orkan.csv, Counties)

names(Orkan.dif) <- c('DOCE', 'TRECE', 'CATORCE', 'QUINCE', "DIECISEIS", "DIECISIETE", 'DELTATRECE', 'DELTACATORCE', 'DELTAQUINCE', "DELTADIECISEIS", "DELTADIESIETE", "COUNTY")

Orkan.dif = round(Orkan.dif, 2)

write.csv(Orkan.dif,"C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/RSHAPE/ORKAN.csv", row.names = FALSE)
was = read.csv("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/RSHAPE/ORKAN.csv")
###Schönen Tag



