#' Main function to retrieve match_region
#'
#' @title Match region input
#' @description Matches user-provided input to valid Brazilian regions using flexible and approximate string matching.
#' @param region Character vector containing user-provided region names.
#' @return A character vector of matched region names.
#' @keywords internal
#' @importFrom dplyr filter mutate select summarise bind_rows left_join
#' @importFrom stringr str_detect str_remove str_to_lower str_sub
#' @importFrom purrr map map_dfr compact
#' @importFrom magrittr %>%
match_region <- function(region) {
  
  region_dict <- c(
    "north" = "north",
    "norte" = "north",
    
    "northeast" = "northeast",
    "nordeste" = "northeast",
    
    "central-west" = "central-west",
    "centro-oeste" = "central-west",
    "centro oeste" = "central-west",
    
    "southeast" = "southeast",
    "sudeste" = "southeast",
    
    "south" = "south",
    "sul" = "south"
  )
  
  # Normalizes dictionary names.
  names(region_dict) <- utils_normalize_text(names(region_dict))
  
  # Normalize input
  region_clean <- utils_normalize_text(region)
  
  result <- vapply(region_clean, function(x) {
    
    if (x %in% names(region_dict)) {
      return(region_dict[[x]])
    }
    
    rlang::abort(
      paste0(
        "Invalid region: '", x, "'.\n\n",
        "Please provide a valid Brazilian region ",
        "using English or Portuguese names.\n\n",
        "Valid options:\n",
        "- 'north' or 'norte' or 'North' or 'Norte' or 'NORTH' or 'NORTE'\n",
        "- 'northeast' or 'nordeste' or 'Northeast' or 'Nordeste' or 'NORTHEAST' or 'NORDESTE'\n",
        "- 'central-west or centro-oeste' or 'Central-west or Centro-oeste' or 'CENTRAL-WEST' or 'CENTRO-OESTE'\n",
        "- 'southeast' or 'sudeste' or 'Southeast' or 'Sudeste' or 'SOUTHEAST' or 'SUDESTE'\n",
        "- 'south' or 'sul' or 'South' or 'Sul' or 'SOUTH' or 'SUL'"
      )
    )
    
  }, character(1))
  
  return(result)
}

# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
