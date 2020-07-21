library(usethis)
library(readxl)
library(readr)
library(dplyr)
library(stringr)

pfi_sitemgmt <-
  readxl::read_excel("data-raw/pfi_sitemgmt/PFIweeds_site_summaries-nice.xlsx", skip = 1) %>%
  mutate_all(funs(stringr::str_replace(., "corn", "maize")))

pfi_sitemgmt %>% write_csv("data-raw/pfi_sitemgmt/pfi_sitemgmt.csv")
usethis::use_data(pfi_sitemgmt, overwrite = TRUE)


