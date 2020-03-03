# updated feb 20 2020 (fixing duplicates, 20190503 was in two raw datasheets)
#                     (moved weed re-naming to this processing step)


# libraries ---------------------------------------------------------------

library(tidyverse)
library(lubridate)
library(janitor)
library(readxl)
library(fs)
library(glue)

#--when they updated tidyr, they broke my function (https://rdrr.io/cran/tidyr/man/nest_legacy.html)
library(tidyr)
nest <- nest_legacy
unnest <- unnest_legacy


# raw data ----------------------------------------------------------------
pfi_eus

rawdat <-
  tibble(files = dir_ls("data-raw/raw_GHobs")) %>%
  filter(str_detect(files, "rd_GHobs")) %>%
  mutate(path = files,
         data = path %>% map(read_excel, skip = 1)) %>%
  select(data) %>%
  unnest(cols = c(data))


# wrangle -----------------------------------------------------------------
#--wow I was not consistent :|


# 1. no changes, just making characters consistently lowercase and filling in dates-------------------

dat1 <-
  rawdat %>%
  remove_empty("rows") %>%
  # make sure date is consistent
  mutate(obs_date = ymd(obs_date)) %>%
  mutate_if(is.character, tolower) %>% #--they aren't consistent w/capitalization
  mutate_if(is.character, str_replace_all, " ", "") %>%  #--sometimes they put spaces
  # drop down obs_date
  fill(obs_date, obs_initials, electrec_initials)



# 2. make col names consistent w/pfi_eus  ---------------------------------
# site_name, field, sys_tr, cc_trt, crop_2019, rep, blockID

dat2 <-
  dat1 %>%
  # get site name
  rename(site_name = location) %>%
  mutate(
    site_name = str_to_title(site_name),
    site_name = recode(site_name,
                      "Funke" = "Funcke")) %>%
  # fix crop_2019
  mutate(
    crop_2019 = str_sub(crop_trt2019, 1, 1), #--extract crop
    crop_2019 = recode(crop_2019,
                       "c" = "corn",
                       "s" = "soy")) %>%
  # get rep from cc_trt
  mutate(
    rep = parse_number(cc_trt)) %>%
  # fix cc_trt
  mutate(cc_trt = tolower(str_sub(cc_trt, 1, -2))) %>%
  # get sys_trt
    mutate(
      sys_trt = parse_character(str_sub(crop_trt2019, 2)), #--extract system
      sys_trt = ifelse(is.na(sys_trt), "grain", "silage")) %>%
  select(-crop_trt2019) %>%
  # make field
  # same as site_name except for Boyd, where B44 is 2019 corn field, B42 is 2019 soy field
  mutate(field = str_sub(site_name, 1, 1),
         field = ifelse(site_name == "Boyd" & crop_2019 == "corn",
                      "B44", field),
         field = ifelse( site_name == "Boyd" & crop_2019 == "soy",
                    "B42", field)) %>%
  # blockID is field_rep
  mutate(blockID = paste0(field, "_", rep))


# 3. make each tray unique ------------------------------------------------

dat3 <-
  dat2 %>%
  mutate(tray = paste0("t", tray),
         trayID = paste(blockID, cc_trt, tray, sep = "-")) %>%
  select(-check, -tray) %>%
  select(obs_date, obs_initials, electrec_initials,
         site_name, field, sys_trt, cc_trt, crop_2019, rep, blockID, trayID,
         everything())

# 4. remove duplicates ----------------------------------------------------

# check for dupes
dp <- get_dupes(dat3)
# that one is a copy-paste error I think. eliminate it


dat4 <-
  dat3 %>% distinct()


# 5. fix weed abbv wrongings ----------------------------------------------
# fix mislabeled weed abbs (they were mislabeled consistently at least)

dat5 <-
  dat4 %>%
  rename(
    "SOLPT" = "SOPT7",
    "CONCA" = "HPPVU",
    "POLAV" = "PALVA",
    "EUPMA" = "EPHMA",
    "RAPSA" = "RAPSR"
  )



pfi_ghobsraw <- dat5

usethis::use_data(pfi_ghobsraw, overwrite = TRUE)


