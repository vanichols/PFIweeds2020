
#' pfifun_sum_weedbyeu
#'
#' @param rawdata Tibble of the form pfi_ghobsraw
#'
#' @return A tibble with total seeds by weed and experimental unit (eu)
#' @export
pfifun_sum_weedbyeu <- function(rawdata){

  assertthat::assert_that(is.data.frame(rawdata), msg = "You must feed me a data.frame")
  assertthat::assert_that("AMATU" %in% colnames(rawdata))

  #--sum by ind species and eu
  datsp <-
    rawdata %>%
    # sum over dates
    dplyr::mutate_if(is.numeric, tidyr::replace_na, 0) %>%
    dplyr::group_by(site_name, field, sys_trt, cc_trt, rep, blockID) %>%
    dplyr::summarise_if(is.numeric, sum) %>%
    tidyr::pivot_longer(
      data = .,
      cols = -(site_name:blockID),
      names_to = "weed",
      values_to = "seeds") %>%
    # 2.8575 cm radius cores, 20 cores per 'rep'
    dplyr::mutate(seeds_m2 = seeds / ( ( (pi * 2.8575^2) * 20 ) / 10000 )) %>%
    # fix mislabeled weed abbs (they were mislabeled consistently at least)
    dplyr::mutate(weed = dplyr::recode(weed,
                         "SOPT7" = "SOLPT",
                         "HPPVU" = "CONCA",
                         "PALVA" = "POLAV",
                         "EUPMA" = "EPHMA")) %>%
    dplyr::ungroup()

  return(datsp)
}


#' pfifun_sum_byeu
#'
#' @param rawdata Tibble of the form pfi_ghobsraw
#'
#' @return A tibble with total seeds per eu
#' @export
pfifun_sum_byeu <- function(rawdata) {

  assertthat::assert_that(is.data.frame(rawdata), msg = "You must feed me a data.frame")
  assertthat::assert_that("AMATU" %in% colnames(rawdata),
                          msg = "You can only feed me the pfi_ghobsraw data.")

  #--sum by ind species and eu
  datsum <-
    rawdata %>%
    # sum over dates
    dplyr::mutate_if(is.numeric, tidyr::replace_na, 0) %>%
    dplyr::group_by(site_name, field, sys_trt, cc_trt, rep, blockID) %>%
    dplyr::summarise_if(is.numeric, sum) %>%
    tidyr::pivot_longer(
      data = .,
      cols = -(site_name:blockID),
      names_to = "weed",
      values_to = "seeds") %>%
    # 2.8575 cm radius cores, 20 cores per 'rep'
    dplyr::mutate(seeds_m2 = seeds / ( ( (pi * 2.8575^2) * 20 ) / 10000 )) %>%
    # fix mislabeled weed abbs (they were mislabeled consistently at least)
    dplyr::mutate(weed = dplyr::recode(weed,
                                       "SOPT7" = "SOLPT",
                                       "HPPVU" = "CONCA",
                                       "PALVA" = "POLAV",
                                       "EUPMA" = "EPHMA")) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(site_name, field, sys_trt, cc_trt, rep, blockID) %>%
    dplyr::summarise(totseeds = sum(seeds, na.rm = T),
              totseeds_m2 = sum(seeds_m2, na.rm = T))

  return(datsum)
}


