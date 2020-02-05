## code to prepare `rd_sitelocs` dataset goes here
library(readxl)
library(dplyr)
pfi_siteinfo <- readxl::read_excel("data-raw/raw_files/rd_site-locs.xlsx") %>%
  dplyr::rename(sys_trt = system)
usethis::use_data(pfi_siteinfo, overwrite = TRUE)


