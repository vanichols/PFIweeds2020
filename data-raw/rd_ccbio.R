## code to prepare `rd_ccbio` dataset goes here
library(tidyverse)
library(readxl)
library(lubridate)
library(janitor)

# Inputs: rd_boyd-trt-key
#         rd_boyd-plot-key
#         rd_kaspar-boyd-ccbio
#         Micki_Boyd42_rye-biomass
#         Micki_Boyd44_rye-biomass

# notes: kasp grain trts only have ccbio every-other-year

# boyd --------------------------------------------------------------------

rd_kasp <-  read_excel("data-raw/raw_ccbio/rd_kaspar-boyd-ccbio.xlsx")
rd_b42 <-  read_excel("data-raw/raw_ccbio/Micki_Boyd42_rye-biomass.xlsx")
rd_b44 <-  read_excel("data-raw/raw_ccbio/Micki_Boyd44_rye-biomass.xlsx")
rd_trtkey <-  read_excel("data-raw/raw_ccbio/rd_boyd-trt-key.xlsx", na = "NA") %>%
  mutate(treatment = as.character(treatment))
rd_plotkey <-  read_excel("data-raw/raw_ccbio/rd_boyd-plot-key.xlsx")
rd_key <- rd_plotkey %>% left_join(rd_trtkey)



# Kaspar data clean -------------------------------------------------------------

td_kasp <-
  rd_kasp %>%
  fill(length_cm:date) %>%
  mutate(year = year(date),
         area_cm2 = length_cm * width_cm) %>%
  # 2016 they use Boyd42
  mutate(field = ifelse(field == "Boyd42", "B42", field)) %>%
  group_by(field, trt_nu, year) %>%
  summarise(ccbio_g = mean(biomass_g, na.rm = T),
            area_cm2 = mean(area_cm2)) %>%
  ungroup() %>%
  mutate(ccbio_gcm2 = ccbio_g / area_cm2,
         ccbio_Mgha = ccbio_gcm2*100,
         trt_nu = as.character(trt_nu)) %>%
  select(field, year, trt_nu, ccbio_Mgha) %>%
  rename(treatment = trt_nu) %>%
  left_join(rd_trtkey) %>%
  filter(!is.na(cc_trt))


# Our 2019 data --------------------------------------------------------------------

rd_boyd19 <-
  bind_rows(rd_b42, rd_b44) %>%
  janitor::clean_names() %>%
  mutate(field = paste0("B", site),
         site = paste0("Boyd", site),
         treatment = as.character(treatment),
         rep = as.character(rep)) %>%
  left_join(rd_key) %>%
  # 32"x12" quadrat, change to ha, change to Mg
  mutate(ccbio_Mgha = weight_g * (1/(32*12)) * 1.55*10^7 * (1/10^6),
         crop_year = 2019) %>%
  select(crop_year, field, site, location,
         treatment, crop_sys, cc_trt,
         plot, rep, sample, weight_g, ccbio_Mgha) %>%
  arrange(crop_year, site, location, treatment, crop_sys, cc_trt, plot, rep, sample)

#write_csv(boyd19raw, "_data/tidy/td-boyd-ryebm2019.csv")

#--average by treatment
td_boyd19 <-
  rd_boyd19 %>%
  rename(year = crop_year) %>%
  group_by(year, field, treatment, location, cc_trt, crop_sys) %>%
  summarise(ccbio_Mgha = mean(ccbio_Mgha, na.rm = T))


# Combine Mickala's msmts w/Keiths -----------------------------------------------

#--weird the grain rotations only have cc_trt every-other year....

allboyd <-
  td_boyd19 %>%
  bind_rows(td_kasp)


# Make it consistent with eus ---------------------------------------------

td_boydccbio <-
  allboyd %>%
  mutate(site_name = str_to_title(location),
         sys_trt = crop_sys) %>%
  ungroup() %>%
  select(site_name, field, sys_trt, cc_trt, year, ccbio_Mgha) %>%
  arrange(site_name, field, sys_trt, cc_trt, year)


# funcke and stout -------------------------------------------------------------------

fsraw <- read_excel("data-raw/raw_ccbio/Stefan_StoutFuncke-covercropbiomass-GNmod.xlsx", na = "NA") %>%
  janitor::clean_names()  %>%
  # get only what I want
  select(location, cooperator, trt, rep, crop_year, cash_crop,
         spring_cc_biomass_lbs_a,
         #spring_cc_sample_date,
         #cc_planting_date,
         #cc_kill_date,
         #cash_crop_planting_date,
  ) %>%
  # rename things to match my conventions
  rename(site = location,
         location = cooperator,
         cc_trt = trt) %>%
  # call it ccrye so it comes first alphabeticaclly (for arranging)
  mutate(cc_trt = recode(cc_trt,
                         Cover = "ccrye",
                         `No cover` = "no")) %>%
  filter(!is.na(rep)) %>%
  arrange(site, location, cc_trt, rep, crop_year) %>%
  # fill things (?)
  # group_by(site, location, crop_year, cash_crop) %>%
  #do(fill(., spring_cc_sample_date)) %>%
  #fill(spring_cc_sample_date:cash_crop_planting_date) %>%
  #ungroup() %>%
  # rename rye now that things are sorted
  mutate(cc_trt = recode(cc_trt,
                         ccrye = "rye")) %>%
  mutate_if(is.character, tolower)


# should deal with things by trt
#
fsrawrye <- fsraw %>% filter(cc_trt == "rye")
fsrawno <- fsraw %>% filter(cc_trt == "no")


# rye data ----------------------------------------------------------------

# why are there some with duplicates? ex Stout rep 1 crop_year 2010
# why do some 'no' have cc biomass?

# I manually fixed everything. The data was just a mess, period. Reps were off, 0s vs NAs, etc

fstidy <-
  fsrawrye %>%

  # make it in Mg/ha
  mutate(ccbio_Mgha = spring_cc_biomass_lbs_a * (1/0.892) * (1/1000)) %>%

  select(site, location, crop_year, cc_trt, everything(), -spring_cc_biomass_lbs_a) %>%

  # I know Stout 2012 cash_crop planting date should read 5/21/2012
  #mutate(cash_crop_planting_date = ifelse(
  #  (location == "stout" & crop_year == 2012),
  #  "5/21/2012",
  #  cash_crop_planting_date
  #)) %>%

  # mutate_at(.vars = vars(spring_cc_sample_date, cc_planting_date, cc_kill_date, cash_crop_planting_date),
  #           .funs = mdy) %>%
  #
# mutate(kpint_days = time_length(interval(ymd(cc_kill_date), ymd(cash_crop_planting_date)), "day"),
#        kpint_days = ifelse(kpint_days > 60, NA, kpint_days)) %>%

arrange(site, location, crop_year, cc_trt, rep)

fstidy


# make it match eus -------------------------------------------------------

td_fsccbio <-
  fstidy %>%
  mutate(site_name = str_to_title(location),
         field = site_name,
         sys_trt = "grain",
         year = crop_year) %>%
  group_by(site_name, field, sys_trt, cc_trt, year) %>%
  summarise(ccbio_Mgha = mean(ccbio_Mgha, na.rm = T)) %>%
  arrange(site_name, field, year) %>%
  ungroup() %>%
  mutate(field = str_sub(field, 1, 1))


# combine boyd and funcke/stout -------------------------------------------

pfi_ccbio <- bind_rows(td_boydccbio, td_fsccbio)

usethis::use_data(pfi_ccbio, overwrite = TRUE)


pfi_mccbio <-
  pfi_ccbio %>%
  group_by(site_name, field, sys_trt, cc_trt) %>%
  summarise(mccbio_Mgha = mean(ccbio_Mgha))

usethis::use_data(pfi_mccbio, overwrite = TRUE)

