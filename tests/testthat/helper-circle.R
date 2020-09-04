library("vcr")
invisible(vcr::vcr_configure(
  filter_sensitive_data = list("R_CIRCLE" = Sys.getenv("R_CIRCLE")),
  dir = "../fixtures"
))
vcr::check_cassette_names()
