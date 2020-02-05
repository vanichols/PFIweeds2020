
#' pfifun_sumwdsp
#'
#' @param rawdata Defaults to pfi_ghobsraw
#'
#' @return A tibble with total seeds by weed and experimental unit (eu)
#' @export
pfifun_sumwdsp <- function(rawdata){

  assertthat::assert_that("SOLPT" %in% colnames(rawdata),
                          msg = "You can only feed me the pfi_ghobsraw data.")

  #--sum by ind species and eu
  datsp <-
    rawdata %>%
    # sum over dates
    dplyr::mutate_if(is.numeric, tidyr::replace_na, 0) %>%
    dplyr::group_by(site_name, sys_trt, crop_2019, cc_trt, rep, repID) %>%
    dplyr::summarise_if(is.numeric, sum) %>%
    tidyr::pivot_longer(
      data = .,
      cols = -(site_name:repID),
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


#' pfifun_sumeu
#'
#' @param sumdata Output from pfi_sumwdsp function
#'
#' @return A tibble with total seeds per eu
#' @export
pfifun_sumeu <- function(sumdata) {

  assertthat::assert_that(is_tibble(sumdata), msg = "You must feed me a tibble")
  assertthat::assert_that("weed" %in% colnames(sumdata),
                          msg = "Did you run pfifun_sumsdsp?\nOnly the output from that function will work here.")

  #--sum total seeds per eu
  datsum <-
    sumdata %>%
    dplyr::group_by(site_name, sys_trt, crop_2019, cc_trt, rep, repID) %>%
    dplyr::summarise(totseeds = sum(seeds, na.rm = T),
              totseeds_m2 = sum(seeds_m2, na.rm = T))

  return(datsum)
}


