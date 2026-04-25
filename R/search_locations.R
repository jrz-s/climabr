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
    
    pattern <- paste(region_match, collapse = "|")
    
    df <- df %>%
      dplyr::filter(
        stringr::str_detect(
          utils_normalize_text(.data$region),
          pattern
        )
      )
  }
  
  # -------- STATE --------
  if (!is.null(state)) {
    
    state_abbr <- match_state(state)
    
    pattern <- paste(state_abbr, collapse = "|")
    
    df <- df %>%
      dplyr::filter(
        stringr::str_detect(.data$state, pattern)
      )
  }
  
  # -------- CITY --------
  if (!is.null(city)) {
    
    city_pattern <- utils_normalize_text(city) %>%
      paste(collapse = "|")
    
    df <- df %>%
      dplyr::mutate(
        city_clean = utils_normalize_text(.data$city_name)
      ) %>%
      dplyr::filter(
        stringr::str_detect(city_clean, city_pattern)
      ) %>%
      dplyr::select(-city_clean)
  }
  
  # -------- VALIDATION --------
  
  #Nenhum resultado
  if (nrow(df) == 0) {
    
    if (!is.null(city) && !is.null(state)) {
      
      rlang::abort(
        paste0(
          "No locations found for city '", city,
          "' in state '", state, "'. ",
          "Please refine your query."
        )
      )
      
    } else if (!is.null(city)) {
      
      rlang::abort(
        paste0(
          "No locations found for city '", city, "'. ",
          "Please refine your query."
        )
      )
      
    } else if (!is.null(state)) {
      
      rlang::abort(
        paste0(
          "No locations found for state '", state, "'. ",
          "Please refine your query."
        )
      )
      
    } else if (!is.null(region)) {
      
      rlang::abort(
        paste0(
          "No locations found for region '", region, "'. ",
          "Please refine your query."
        )
      )
      
    } else {
      
      rlang::abort(
        "No locations found. Please refine your query."
      )
    }
  }
  
  #Multiplos resultados (quando city foi usada)
  if (!is.null(city) && nrow(df) > 1) {
    rlang::abort(
      paste0(
        "Multiple cities matched '", city, "'. ",
        "Please provide a more specific name."
      )
    )
  }
  
  return(df)
}