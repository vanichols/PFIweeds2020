
#' Cover crop biomass production for each year/field
#'
#'
#' @format A data frame with 56 rows and 6 variables:
#' \describe{
#'   \item{site_name}{Boyd, Stout, Funcke; the name of the site, the link to pfi_eus}
#'   \item{field}{B42, B44, S, F; id of the field within the site, only Boyd had multiple fields}
#'   \item{sys_trt}{silage, grain}
#'   \item{cc_trt}{no, rye}
#'   \item{year}{the year the spring cover crop biomass was measured}
#'   \item{ccbio_Mgha}{the amount of cover crop biomass in Mg/ha; 1000 kg = 1 Mg}
#'
#'
#'   ...
#' }
"pfi_ccbio"

#' Unique identifiers of the experimental units and blocks
#'
#' A dataset containing information about each experimental unit of the research
#'
#' @format A data frame with 56 rows and 7 variables:
#' \describe{
#'   \item{site_name}{Boyd, Stout, Funcke; name of the physical site}
#'   \item{field}{Boyd42, Boyd44, Stout, Funcke; name of the field within the site}
#'   \item{sys_trt}{silage, grain}
#'   \item{cc_trt}{no, rye}
#'   \item{crop_2019}{corn, soy; the crop that was planted in spring of 2019}
#'   \item{rep}{Numeric rep, defined within a site}
#'   \item{repID}{A concatonation of the field identifier, the sys_trt, underscore numeric rep. This creates a unique identifier for each block in each field at each site.}
#'   ...
#' }
"pfi_eus"



#' Raw weed counts
#'
#' A dataset containing all of the observations made on the trays, weed names have NOT been fixed
#'
#' @format A data frame with 430 rows and 31 variables:
#' \describe{
#'   \item{obs_date}{date, in yyy-mm-dd format, the weed counts were recorded}
#'   \item{obs_initials}{initials of person who observed the data}
#'   \item{electrec_initials}{initals of person who electronically scribed the data}
#'   \item{site_name}{Boyd, Stout, Funcke; the name of the site, the link to pfi_eus}
#'   \item{field}{B42, B44, S, F; name of the field within the site}
#'   \item{sys_trt}{silage, grain}
#'   \item{cc_trt}{no, rye}
#'   \item{crop_2019}{corn, soy; crop grown in 2019 on that field}
#'   \item{rep}{the field replicate}
#'   \item{blockID}{the unique identifier for the block}
#'   \item{trayID}{the unique identifier for the tray; in general each eu had 3 trays}
#'   \item{AMATU}{the weed code for the observed weed, see pfi_weedsplist}
#'
#'
#'   ...
#' }
"pfi_ghobsraw"

#' Mean cover crop biomass production for each field
#'
#'
#' @format A data frame with 6 rows and 5 variables:
#' \describe{
#'   \item{site_name}{Boyd, Stout, Funcke; the name of the site, the link to pfi_eus}
#'   \item{field}{B42, B44, S, F; name of the field within the site}
#'   \item{sys_trt}{silage, grain}
#'   \item{cc_trt}{no, rye}
#'   \item{mccbio_Mgha}{the amount of cover crop biomass averaged over all years in Mg/ha; 1000 kg = 1 Mg}
#'
#'
#'   ...
#' }
"pfi_mccbio"

#' Information about the cooperators and general site info
#'
#' A dataset containing information about the cooperators and general site info
#'
#' @format A data frame with 4 rows and 6 variables:
#' \describe{
#'   \item{coop_name}{Kohler, Stout, Funcke; the last name of the cooperator}
#'   \item{site_name}{Boyd, Stout, Funcke; the name of the site, the link to pfi_eus}
#'   \item{sys_trt}{silage, grain, included for mapping purposes mostly}
#'   \item{city}{Closest Iowan city to site}
#'   \item{lat}{Latidude in decimal form, N}
#'   \item{lon}{Longitude in decimal form, W}
#'   \item{county}{County of site}
#'
#'
#'   ...
#' }
"pfi_siteinfo"

#' Weed abbreviations and descriptions
#'
#' @format A data frame with 16 rows and 7 variables:
#' \describe{
#'   \item{common_name}{common name of weed}
#'   \item{scientific_name}{scientific name of weed, genus and species}
#'   \item{code}{weed code}
#'   \item{possible_mislabel}{corrections made to original dataset, corrected version appears in pfi_ghobsraw data}
#'   \item{photo_path}{photosynthetic pathway, C3 or C4}
#'   \item{functional_grp}{functional group of weed, forb or grass}
#'   \item{family}{weed family}
#'
#'
#'   ...
#' }
"pfi_weedsplist"

