library(readxl)
library(dplyr)
library(lubridate)
library(readr)

wearaw <-
  readxl::read_excel("data-raw/pfi_wea/nwscoop_wea_30yrs.xlsx")


pfi_wea <-
  wearaw %>%
  mutate(site_name =
             case_when(
             grepl("WASH", station_name) ~ "East",
             grepl("AMES", station_name) ~ "Central",
                grepl("JEFF", station_name) ~ "West"),
         year = lubridate::year(day)) %>%
  group_by(site_name, year) %>%
  summarise(highc = mean(highc, na.rm = TRUE),
            lowc = mean(lowc, na.rm = TRUE),
            precip = sum(precipmm)) %>%
  mutate(avgc = (highc + lowc)/2) %>%
  group_by(site_name) %>%
  summarise(avgT_c = mean(avgc),
            avgp_mm = mean(precip))


pfi_wea %>% readr::write_csv("data-raw/pfi_wea/pfi_wea.csv")
usethis::use_data(pfi_wea, overwrite = TRUE)


