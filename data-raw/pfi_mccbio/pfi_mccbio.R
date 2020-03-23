# updated march 23 2020 to jarad-style folders

library(tidyverse)

pfi_ccbio <- read_csv("data-raw/pfi_ccbio/pfi_ccbio.csv")

pfi_mccbio <-
  pfi_ccbio %>%
  group_by(site_name, field, sys_trt, cc_trt) %>%
  summarise(mccbio_Mgha = mean(ccbio_Mgha))


pfi_mccbio %>% write_csv("data-raw/pfi_mccbio/pfi_mccbio.csv")
usethis::use_data(pfi_mccbio, overwrite = TRUE)

