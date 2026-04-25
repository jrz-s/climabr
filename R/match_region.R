#' Main function to retrieve match_region
#'
#' @title Match region input
#' @description Matches user-provided input to valid Brazilian regions using flexible and approximate string matching.
#' @param region_input Character vector containing user-provided region names.
#' @return A character vector of matched region names.
#' @keywords internal
#' @importFrom dplyr filter mutate select summarise bind_rows left_join
#' @importFrom stringr str_detect str_remove str_to_lower str_sub
#' @importFrom purrr map map_dfr compact
#' @importFrom magrittr %>%
match_region <- function(region) {
  
  valid_regions <- c(
    "north", "northeast", "central-west",
    "southeast", "south"
  )
  
  region_clean <- utils_normalize_text(region)
  
  if (!region_clean %in% valid_regions) {
    rlang::abort(
      paste0(
        "Invalid region: '", region, "'. ",
        "Please provide a valid region (north, northeast, central-west, southeast, south)."
      )
    )
  }
  
  return(region_clean)
}