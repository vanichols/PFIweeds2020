## code to prepare `rd_eus` dataset goes here
pfi_eus <-
  read_csv("data-raw/pfi_eus/rd_euIDs-new.csv") %>%
  select(site_name, sys_trt, cc_trt, crop_2019, rep) %>%
  #--fix Funcke spelling
  mutate(site_name = recode(site_name,
                            "Funke" = "Funcke")) %>%
  #--make a site_name and field separately
  mutate(field = site_name,
         site_name = str_replace_all(site_name, "[:digit:]", ""),
         fieldtmp = ifelse(grepl("Boyd", field),
                           paste0("B", parse_number(field)),
                           str_sub(field, 1, 1))) %>%
  mutate(blockID = paste0(fieldtmp,
                        #(str_sub(sys_trt, 1, 1)),
                       #str_sub(crop_2019, 1, 1),
                       "_",
                       rep)) %>%
  select(site_name, fieldtmp, sys_trt, cc_trt, crop_2019, rep, blockID) %>%
  rename(field = fieldtmp)

pfi_eus %>% write_csv("data-raw/pfi_eus/pfi_eus.csv")
usethis::use_data(pfi_eus, overwrite = TRUE)
