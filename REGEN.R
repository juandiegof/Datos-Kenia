rm(list=ls())
setwd("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/RSHAPE")

library(rgdal)
library(ncdf4)
library(raster)
library(dplyr)



shp = readOGR("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/kenyan-counties/County.shp")
reg = nc_open("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/dosmiltrece.nc")

reg1.brick = brick("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/dosmiltrece.nc")

extent(reg1.brick)

crs(shp)

crs(reg1.brick) 

#MAGIA

reg1.mask = mask(reg1.brick, shp)


pre1.df = as.data.frame(pre1.mask[[1]], xy=TRUE)

pre1.df = pre1.df[complete.cases(pre1.df),]
head(pre1.df)

###HIER GEHEN WIR

plot(reg1.mask)

#### a poligono
kis_stk = stack(reg1.mask)

rgdal::readOGR("C:/Users/JUAN DIEGO/Downloads/U/Memoria/TAMSAT/kenyan-counties/County.shp", stringsAsFactors = F) %>%
  sp::spTransform(CRS(projection(kis_stk[[1]]))) -> basin

reg1.mask[[368,]]


##### EUREKA!!!!!!!!!
tres = extract(kis_stk, spPolygons(basin[3,]), fun= mean, na.rm= TRUE)


trece = vector(mode = "character", length = 47)
for (i in 1:12){
  trece[i] =  sum(extract(kis_stk, spPolygons(basin[i,]), fun= mean, na.rm= TRUE))
}


diff(trece)

### DAS ENDE



### Lo que no sirvió
