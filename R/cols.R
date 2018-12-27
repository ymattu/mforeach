#' terator for data frame by column
#' @import iterators
#' @param df dataframe
#' @export
cols <- function (df)
{
  iterators::iter(df, by = "col")
}
