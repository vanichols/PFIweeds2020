# updated march 23 2020 (change to jarad-style file structure)

pfi_weedsplist <- read_csv("data-raw/pfi_weedsplist/weed-spp-list.csv")

pfi_weedsplist %>% write_csv("data-raw/pfi_weedsplist/pfi_weedsplist.csv")
usethis::use_data(pfi_weedsplist, overwrite = TRUE)
