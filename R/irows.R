#' Iterator for row number of a data frame
#' @param df data frame
#' @import iterators
#' @export
irows <- function (df)
{
  iterators::icount(nrow(df))
}
