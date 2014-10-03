#'
#' @title Creates 2-dimensional contingency tables - potentially disclosive data are suppressed
#' @description The function table2d.ds is a server-side subfunction of datashield.aggregate(). 
#' It generates 2-dimensional tables for all data sources. Valid (non-disclosive) data are defined as data 
#' from sources where no table cells have counts between 1 and 4 (the upper value [4] can in principle be 
#' changed but only by rewriting the underlying function - it cannot be changed by a standard DataSHIELD user). 
#' If the count in any cell in the table produced by a given data source IS invalid, that cell count is changed 
#' to "-1" and the name of the two categories that correspond to it are both changed to "-9". Each source is flagged 
#' as having only valid data, or at least some invalid data.Missing data are treated as na.action=na.omit 
#' (default for table function), if missing data are to be treated as
#' a separate and visible category, the variable should first be transformed to convert NAs to the a new value.
#' @param xvect a numerical vector with discrete values - usually a factor
#' @param yvect a numerical vector with discrete values - usually a factor
#' @return A list object (eg. named out.obj) with one component from each separate study which contains the following items:
#' \item{is.table.valid}{eg. out.obj[[2]]$is.table.valid is a logical (Boolean) indicator of whether the data in study 2 is 
#' entirely valid (TRUE) for the stated variable or at least one category is invalid (FALSE)}
#' \item{safe.table}{eg. out.obj[[1]]$safe.table contains the safe (non-disclosive) one dimensional table that can be released 
#' from study 1 - unsafe data are concealed by converting invalid counts to "-1" and their corresponding catregory identifier to "-9"}
#' @author Burton P.
#' @export
#' 
table2dDS <- function(xvect,yvect){

  # Assign vector of interest
  vect1_os2 <- xvect
  vect2_os2 <- yvect
  
  # assign character names to the variables
  var.name.1_os2 <- "VAR.1"
  var.name.2_os2 <- "VAR.2"
  
  # assign vector of interest to be factor_is1
  factor1_is1 <- vect1_os2
  factor2_is1 <- vect2_os2
   
  # assign its name from get.var.names.script
  var.name.1_is1 <- var.name.1_os2
  var.name.2_is1 <- var.name.2_os2

  # reset to K+1 if the non-allowable range is changed to 1 to K  
  critical.min <- setFilterDS()
  
  table.valid <- TRUE
  
  table.new <- table(factor1_is1,factor2_is1,dnn=c(var.name.1_is1,var.name.2_is1))
  
  nnr <- dim(table.new)[1]
  nnc <- dim(table.new)[2]

  for(j in 1:nnr)
  {
    for(k in 1:nnc)
    {
       if(table.new[j,k]<critical.min && table.new[j,k] > 0)
        {
        table.new[j,k] <- (-1)
        table.valid <- FALSE
        dimnames(table.new)[[1]][j] <- (-9)
        dimnames(table.new)[[2]][k] <- (-9)
        }
    }
  }
  # names(dimnames(table.new)) <- paste("Categories/Counts for Variable:\n",var.name.1_is1)
  # names(table.valid) <- paste(var.name.1_is1,var.name.2_is1)
  out.list_os1 <- list(table.valid,as.table(table.new))
  names(out.list_os1) <- list("is.table.valid","safe.table")
  
  # returns 1 key output object
  return(out.list_os1)
}
