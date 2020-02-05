## code to prepare `rd_eus` dataset goes here
pfi_eus <-
  rd_eus %>%
  select(site_name, sys_trt, cc_trt, crop_2019, rep) %>%
  mutate(site_name = recode(site_name,
                            "Funke" = "Funcke")) %>% #--fix Funcke spelling
  mutate(repID = paste0(str_sub(site_name, 1, 1),
                       str_sub(sys_trt, 1, 1),
                       str_sub(crop_2019, 1, 1),
                       "_",
                       rep)) %>%
  mutate(coop_name = case_when(
    grepl("Boyd", site_name) ~ "Kohler",
    grepl("Funcke", site_name) ~ "Funcke",
    grepl("Stout", site_name) ~ "Stout"))

usethis::use_data(pfi_eus, overwrite = TRUE)
