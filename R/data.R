#' Unique identifiers of the experimental units
#'
#' A dataset containing information about each experimental unit of the research
#'
#' @format A data frame with 56 rows and 7 variables:
#' \describe{
#'   \item{site_name}{Boyd42, Boyd44, Stout, Funcke; name of the physical site}
#'   \item{sys_trt}{silage, grain}
#'   \item{cc_trt}{no, rye}
#'   \item{crop_2019}{corn, soy; the crop that was planted in spring of 2019}
#'   \item{rep}{Numeric rep, defined within a site}
#'   \item{repID}{A concatonation of the first letter of the site_name, the sys_trt, the crop_2019, underscore numeric rep. This creates a unique identifier for each block at each site.}
#'   \item{coop_name}{Kohler, Stout, Funcke; the last name of the cooperator, matches with pfi_siteinfo data.}
#'   ...
#' }
"pfi_eus"

#' Information about the cooperators and general site info
#'
#' A dataset containing information about the cooperators and general site info
#'
#' @format A data frame with 4 rows and 6 variables:
#' \describe{
#'   \item{coop_name}{Kohler, Stout, Funcke; the last name of the cooperator, matches with pfi_siteinfo data.}
#'   \item{sys_trt}{silage, grain}
#'   \item{city}{Closest Iowan city to site}
#'   \item{lat}{Latidude in decimal form, N}
#'   \item{lon}{Longitude in decimal form, W}
#'   \item{county}{County of site}
#'
#'   ...
#' }
"pfi_siteinfo"
