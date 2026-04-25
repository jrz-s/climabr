climabr
================

<!-- badges: start -->

<!-- badges: end -->

An R package for providing historical (30-year) average monthly
climatological data (minimum temperature, maximum temperature, and
precipitation) for municipalities in Brazil. Data are retrieved from the
Climatempo platform through automated web scraping. The package provides
flexible tools for location search and structured climate data
extraction, supporting applications in ecology, environmental science,
and data science.

This package is intended for research and educational purposes, and
users should ensure compliance with the terms of use of the data source.

------------------------------------------------------------------------

## Installation

You can install the development version of **climabr** from GitHub:

``` r
# Install development version from GitHub
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

remotes::install_github("jrz-s/climabr")
```

## Overview

**climabr** enables users to:

- Search for locations using flexible input (region, state, or city)
- Retrieve monthly climatological data (temperature and precipitation)
- Handle partial, case-insensitive, and accent-insensitive queries
- Aggregate data across multiple locations

## Example

``` r
library(climabr)

# Retrieve climate list for Aracaju (Sergipe, Brazil)
df <- search_locations(state = "se", city = "aracaju")
climate_list(df)

# Retrieve climate data for Aracaju (Sergipe, Brazil)
climate_data(state = "se", city = "aracaju")
```

## Input flexibility

The package supports robust matching of user inputs:

- Partial names (e.g., “arac” → “aracaju”)
- Case-insensitive matching (e.g., “Sergipe” = “sergipe”)
- Accent-insensitive matching (e.g., “São” = “Sao”)
- Informative error messages for ambiguous inputs

## Workflow

A typical workflow consists of:

1.  Searching locations using `search_locations()`
2.  Retrieving climate data using `climate_data()`
3.  Performing downstream analysis or visualization

## Output

The main function returns a tidy tibble with the following variables:

`region:` Geographic region `state:` State abbreviation `city_name:`
City name `site:` Site identifier (optional) `month:` Month (1–12)
`tmin:` Minimum temperature (°C) `tmax:` Maximum temperature (°C)
`precip:` Precipitation (mm)

## Disclaimer

This package performs automated web scraping from the Climatempo website
to facilitate access to publicly available climatological data. It is
designed to support research, educational, and non-commercial
applications by providing a structured and reproducible approach to
retrieving climate information.

Users are responsible for ensuring that their use of this package
complies with the terms of service and policies of the data provider.

When using this package, users should:

- Avoid excessive or high-frequency requests that may overload the
  source servers
- Implement appropriate delays between requests
- Use the data responsibly and ethically

The authors are not affiliated with, endorsed by, or sponsored by
Climatempo.

This package is provided “as is” without warranty of any kind. Its
functionality may change over time as the source website evolves, and
users should be aware that web scraping workflows are inherently subject
to structural changes in the data source.

## Author

Jhonatan Rafael Zárate-Salazar, PhD<br> Postdoctoral Researcher<br>
Graduate Program in Ecology and Conservation<br> Federal University of
Sergipe (UFS), São Cristóvão, Sergipe, Brazil<br>

📧 Email: <rzaratesalazar@gmail.com><br> 🔗 ORCID:
<https://orcid.org/0000-0001-9251-5340><br> 💻 GitHub:
<https://github.com/jrz-s><br> 🎓 Google Scholar:
<https://scholar.google.com/citations?user=6ECRpM4AAAAJ&hl=pt-BR><br>

## Collaborators

Eduardo Vinícius S. Oliveira, PhD<br> Postdoctoral Researcher, Graduate
Program in Ecology and Conservation<br> Federal University of Sergipe,
São Cristóvão, Sergipe, Brazil<br>

Sidney Feitosa Gouveia, PhD<br> Professor, Department of Ecology<br>
Federal University of Sergipe, São Cristóvão, Sergipe, Brazil
