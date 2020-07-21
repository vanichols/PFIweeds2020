library(usethis)
library(readxl)
library(readr)
library(dplyr)
library(stringr)

pfi_herbicidekey <-
  readxl::read_excel("data-raw/pfi_herbicidekey/herbicide-produce-key.xlsx")

pfi_herbicidekey %>%
  write_csv("data-raw/pfi_herbicidekey/pfi_herbicidekey.csv")

usethis::use_data(pfi_herbicidekey, overwrite = TRUE)


