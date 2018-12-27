#' Iterator for column number of a data frame
#' @param df data frame
#' @import iterators
#' @export
icols <- function (df)
{
  iterators::icount(ncol(df))
}
