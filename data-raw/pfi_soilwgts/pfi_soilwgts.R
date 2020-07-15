library(usethis)
library(readxl)
library(readr)
library(dplyr)

pfi_soilwgts <-
  readxl::read_excel("data-raw/pfi_soilwgts/raw_soil-wgts.xlsx")

pfi_soilwgts %>% write_csv("data-raw/pfi_soilwgts/pfi_soilwgts.csv")
usethis::use_data(pfi_soilwgts, overwrite = TRUE)


