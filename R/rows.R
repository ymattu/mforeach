#' Iterator for data frame by row
#' @param df data frame
#' @import iterators
#' @export
rows <- function (df)
{
  iterators::iter(df, by = "row")
}
