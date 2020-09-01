# updated march 23 2020 (change to jarad-style file structure)
# july 14 2020 changed UB to UD and UG to UM
# RAPSA should be RAPSR, that isn't a mislabel (??)
# Neither is HPPVU

library(tidyverse)

pfi_weedsplist <-
  read_csv("data-raw/pfi_weedsplist/weed-spp-list.csv") %>%
  mutate(
    common_name =
      recode(
        common_name,
        "Unknown grass" = "Unknown monocotyledon",
        "Unknown broadleaf" = "Unknown dicotyledon"
      ),
    scientific_name =
      recode(
        scientific_name,
        "conyza canadensis" = "erigeron canadensis" #--there are two Bayer entries, ??
      ),
    code =
      recode(code,
             "UG" = "UM",
             "UB" = "UD",
             "RAPSA" = "RAPSR", #--not a mislabel
             "CONCA" = "ERICA",
             "SOLPT" = "SOPT7" #--not a mislabel
             )
  ) %>%
  #--don't leave sci name blank for unknowns
  mutate(scientific_name = case_when(
    code == "UM" ~ "Unknown Monocotyledon",
    code == "UD" ~ "Unknown Dicotyledon",
    TRUE ~ scientific_name
  )) %>%
  mutate(scientific_name = stringr::str_to_sentence(scientific_name))



pfi_weedsplist %>% write_csv("data-raw/pfi_weedsplist/pfi_weedsplist.csv")
usethis::use_data(pfi_weedsplist, overwrite = TRUE)
