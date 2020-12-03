rm(list = ls())

setwd("C:/Users/JUAN DIEGO/Downloads/U/Memoria/GCP")

library(readxl)
library(janitor)

gcp = read_excel("GCP report 2019-seiten-35.xlsx")

gcp <- gcp %>%
  row_to_names(row_number = 1)

gcp <- gcp[-c(48,49),]

gcp <- gcp[order(gcp$County),]

write.csv(gcp, "GCP.csv", row.names = FALSE)
was <- read.csv("gcp.csv")
