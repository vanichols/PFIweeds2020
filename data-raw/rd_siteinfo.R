## code to prepare `rd_sitelocs` dataset goes here
library(readxl)
library(dplyr)

pfi_siteinfo <-
  readxl::read_excel("data-raw/raw_files/rd_site-locs.xlsx") %>%
  dplyr::rename(sys_trt = system) %>%
  mutate(site_name =
             case_when(
             grepl("Kohler", coop_name) ~ "Boyd",
             grepl("Funcke", coop_name) ~ "Funcke",
                grepl("Stout", coop_name) ~ "Stout")) %>%
  select(coop_name, site_name, sys_trt, lat, lon, city, county)
usethis::use_data(pfi_siteinfo, overwrite = TRUE)


