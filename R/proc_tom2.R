
#' pfifun_seedstom2conv
#'
#' @param totseeds Number of seeds found in a plot
#'
#' @return Seeds per plot converted to seeds per m2 assuming 20 cores per plot
#' @export


pfifun_seedstom2conv <- function(totseeds){

tom2conv <- 1 / (((pi * 2.8575^2) * 20 ) / 10000 )

totseedsm2 <- totseeds * tom2conv

return(totseedsm2)
}
