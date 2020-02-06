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
