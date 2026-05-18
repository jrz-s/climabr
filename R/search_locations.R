#' Main function to retrieve search_locations
#'
#' @title Search locations
#' @description Searches the internal location database using flexible matching for region, state, and city names.
#' @param region Character. Optional region name.
#' @param state Character. State abbreviation or full name.
#' @param city Character. City name (partial or full).
#' @return A tibble containing matching locations and associated metadata, including region, state, city name, and data source links.
#' @examples
#' search_locations(state = "se", city = "arac")
#' @importFrom dplyr filter mutate select summarise bind_rows left_join
#' @importFrom stringr str_detect str_remove str_to_lower str_sub
#' @importFrom purrr map map_dfr compact
#' @importFrom magrittr %>%
#' @export
search_locations <- function(region = NULL,
                             state = NULL,
                             city = NULL) {
  
  df <- linksdataset
  
  # -------- REGION --------
  if (!is.null(region)) {
    
    region_match <- match_region(region)
    
    df <- df %>%
      dplyr::filter(
        utils_normalize_text(.data$region) %in% region_match
      )
  }
  
  # -------- STATE --------
  if (!is.null(state)) {
    
    state_abbr <- match_state(state)
    
    df <- df %>%
      dplyr::filter(
        .data$state %in% state_abbr
      )
  }
  
  # -------- CITY --------
  if (!is.null(city)) {
    
    # User input: slug
    city_clean_input <- utils_normalize_slug(city)
    
    # Dataset: slug
    df <- df %>%
      dplyr::mutate(
        city_clean = utils_normalize_slug(.data$city_name)
      )
    
    # -------- EXACT MATCH --------
    
    df_exact <- df %>%
      dplyr::filter(
        city_clean %in% city_clean_input
      )
    
    # Check if ALL cities were found.
    if (
      length(unique(df_exact$city_clean)) ==
      length(city_clean_input)
    ) {
      
      df <- df_exact
      
    } else {
      
      # -------- PARTIAL MATCH --------
      
      pattern <- paste(city_clean_input, collapse = "|")
      
      df_partial <- df %>%
        dplyr::filter(
          stringr::str_detect(city_clean, pattern)
        )
      
      # Real ambiguity:
      # only when ONE city was provided
      if (
        length(city_clean_input) == 1 &&
        nrow(df_partial) > 1
      ) {
        
        rlang::abort(
          paste0(
            "Multiple cities matched '", city, "'. ",
            "Please provide a more specific name."
          )
        )
      }
      
      df <- df_partial
    }
    
    # Remove auxiliary column
    df <- df %>%
      dplyr::select(-city_clean)
  }
  
  # -------- VALIDATION --------
  
  if (nrow(df) == 0) {
    
    if (!is.null(city) && !is.null(state)) {
      
      rlang::abort(
        paste0(
          "No locations found for city '",
          paste(city, collapse = ", "),
          "' in state '", state, "'. ",
          "Please refine your query."
        )
      )
      
    } else if (!is.null(city)) {
      
      rlang::abort(
        paste0(
          "No locations found for city '",
          paste(city, collapse = ", "),
          "'. Please refine your query."
        )
      )
      
    } else if (!is.null(state)) {
      
      rlang::abort(
        paste0(
          "No locations found for state '", state,
          "'. Please refine your query."
        )
      )
      
    } else if (!is.null(region)) {
      
      rlang::abort(
        paste0(
          "No locations found for region '", region,
          "'. Please refine your query."
        )
      )
      
    } else {
      
      rlang::abort(
        "No locations found. Please refine your query."
      )
    }
  }
  
  return(df)
}

# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
