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

allboyd <-
  td_boyd19 %>%
  bind_rows(td_kasp)


# Make it consistent with eus ---------------------------------------------








usethis::use_data(pfi_eus, overwrite = TRUE)
