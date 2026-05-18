#' Main function to retrieve match_state
#'
#' @title Match state input
#' @description Matches user-provided input to valid Brazilian state abbreviations using flexible and approximate string matching.
#' @param state Character vector containing user-provided state names or abbreviations.
#' @return A character vector of matched state abbreviations.
#' @keywords internal
#' @importFrom dplyr filter mutate select summarise bind_rows left_join
#' @importFrom stringr str_detect str_remove str_to_lower str_sub
#' @importFrom purrr map map_dfr compact
#' @importFrom magrittr %>%
match_state <- function(state) {
  
  state_dict <- c(
    "acre" = "ac",
    "alagoas" = "al",
    "amapa" = "ap",
    "amazonas" = "am",
    "bahia" = "ba",
    "ceara" = "ce",
    "distrito federal" = "df",
    "espirito santo" = "es",
    "goias" = "go",
    "maranhao" = "ma",
    "mato grosso" = "mt",
    "mato grosso do sul" = "ms",
    "minas gerais" = "mg",
    "para" = "pa",
    "paraiba" = "pb",
    "parana" = "pr",
    "pernambuco" = "pe",
    "piaui" = "pi",
    "rio de janeiro" = "rj",
    "rio grande do norte" = "rn",
    "rio grande do sul" = "rs",
    "rondonia" = "ro",
    "roraima" = "rr",
    "santa catarina" = "sc",
    "sao paulo" = "sp",
    "sergipe" = "se",
    "tocantins" = "to"
  )
  
  # Normalizes dictionary names.
  names(state_dict) <- utils_normalize_text(names(state_dict))
  
  valid_states <- unname(state_dict)
  
  state_clean <- utils_normalize_text(state)
  
  result <- vapply(state_clean, function(x) {
    
    # Case 1: valid acronym
    if (x %in% valid_states) {
      return(x)
    }
    
    # Case 2: Valid full name
    if (x %in% names(state_dict)) {
      return(state_dict[[x]])
    }
    
    # Case 3: Invalid
    rlang::abort(
      paste0(
        "Invalid state: '", x, "'.\n\n",
        "Please provide a valid Brazilian state ",
        "name or abbreviation.\n\n",
        "Examples of valid inputs:\n",
        "- 'Sergipe' or 'SE' or 'se'\n",
        "- 'Pernambuco' or 'PE' or 'pe'",
        "- 'Rio Grande do Sul' or 'RS' or 'rs'"
      )
    )
    
  }, character(1))
  
  return(result)
}

# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
