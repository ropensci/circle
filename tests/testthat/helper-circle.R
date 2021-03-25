library("vcr")
invisible(vcr::vcr_configure(
  filter_sensitive_data = list(
    "<<<R_CIRCLE>>>" = Sys.getenv("R_CIRCLE"),
    "<<<PAT_GITHUB>>>" = Sys.getenv("PAT_GITHUB")
  ),
  dir = "../fixtures",
  log = FALSE,
  log_opts = list(file = "console")
))
vcr::check_cassette_names()

# set repo with access right on Circle CI here for local testing
Sys.setenv("CIRCLE_REPO" = "circle")
Sys.setenv("CIRCLE_OWNER" = "ropensci")
