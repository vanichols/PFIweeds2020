# Author: Gina Nichols (vnichols@iastate.edu)
# Created: Feb 4 2020
# Purpose: Read in greenhouse observation sheets
# Notes: Derived from 01_read-GHobs in Box folder, moving to package format
#        Weed codes are NOT fixed in this data
#
# Last modified:



# libraries ---------------------------------------------------------------

library(tidyverse)
library(lubridate)
library(janitor)
library(readxl)
library(fs)

#--when they updated tidyr, they broke my function (https://rdrr.io/cran/tidyr/man/nest_legacy.html)
library(tidyr)
nest <- nest_legacy
unnest <- unnest_legacy


# raw data ----------------------------------------------------------------

rawdat <-
  tibble(files = dir_ls("data-raw/raw_GHobs")) %>%
  filter(str_detect(files, "rd_GHobs")) %>%
  mutate(path = files,
         data = path %>% map(read_excel, skip = 1)) %>%
  select(data) %>%
  unnest(cols = c(data))


# wrangle -----------------------------------------------------------------

#--wow I was not consistent :|

dat <-
  rawdat %>%
  remove_empty("rows") %>%
  # remove unneeded cols
  select(-check, -tray, -obs_initials, -electrec_initials) %>%
  # make sure date is consistent
  mutate(obs_date = ymd(obs_date)) %>%
    mutate_if(is.character, tolower) %>% #--they aren't consistent w/capitalization
    mutate_if(is.character, str_replace_all, " ", "") %>%  #--sometimes they put spaces
      # drop down obs_date
  fill(obs_date) %>%
  # make things consistent with pfi_eus
  mutate(
    location = str_to_title(location),
    location = recode(location,
                           "Funke" = "Funcke"),
         crop_2019 = str_sub(crop_trt2019, 1, 1), #--extract crop
         crop_2019 = recode(crop_2019,
                            "c" = "corn",
                            "s" = "soy"),
         sys_trt = parse_character(str_sub(crop_trt2019, 2)), #--extract system
         sys_trt = ifelse(is.na(sys_trt), "grain", "silage"),
         rep = parse_number(cc_trt),
         cc_trt = tolower(str_sub(cc_trt, 1, -2)),
         site_name = location,
         site_name = ifelse( site_name == "Boyd" & crop_2019 == "corn",
                             "Boyd44", site_name),
         site_name = ifelse( site_name == "Boyd" & crop_2019 == "soy",
                             "Boyd42", site_name)) %>%
    # create repIDs that match the pfi_eus
    mutate(repID = paste0(str_sub(site_name, 1, 1),
                          str_sub(sys_trt, 1, 1),
                          str_sub(crop_2019, 1, 1),
                          "_",
                          rep)) %>%
    mutate(coop_name = case_when(
      grepl("Boyd", site_name) ~ "Kohler",
      grepl("Funcke", site_name) ~ "Funcke",
      grepl("Stout", site_name) ~ "Stout")) %>%
    # remove old rows
    select(-location, -crop_trt2019) %>%
    select(obs_date, site_name,
           coop_name, sys_trt,
           crop_2019, cc_trt,
           rep, repID, everything()) %>%
    arrange(obs_date, site_name, sys_trt, cc_trt, rep)


# get into same format as eus ---------------------------------------------

td_ghobs <-
  dat %>%
  #--make a site_name and field separately
  mutate(field = site_name,
         site_name = str_replace_all(site_name, "[:digit:]", ""),
         fieldtmp = ifelse(grepl("Boyd", field),
                           paste0("B", parse_number(field)),
                           str_sub(field, 1, 1))) %>%
  mutate(repID = paste0(fieldtmp,
                        (str_sub(sys_trt, 1, 1)),
                        #str_sub(crop_2019, 1, 1),
                        "_",
                        rep)) %>%
  select(obs_date, site_name, fieldtmp,
         sys_trt, cc_trt,
         crop_2019,
         rep, repID,
         everything(),
         -coop_name, -crop_2019, -field) %>%
  rename(field = fieldtmp)

pfi_ghobsraw <- td_ghobs

usethis::use_data(pfi_ghobsraw, overwrite = TRUE)


