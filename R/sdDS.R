#'
#' @title Computes the standard deviation of vector with more than 4 entries
#' @description Calculates the standard deviation.
#' @details if the length of input vector is less than the set filter
#' a missing value is returned. 
#' @param xvect a vector
#' @return a numeric, the standard deviation
#' @author Gaye, A; Scherer, P
#' @export
#'
sdS <- function (xvect) {
  
  # check if the input vector is valid (i.e. meets DataSHIELD privacy criteria)
  check <- isValidDS(xvect)
  
  if(check){
    result <- sd(xvect, na.rm=TRUE) 
  }else{
    result <- NA
  }
  
  return(result)
}
