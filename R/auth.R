#' Authenticate to circle
#' @description
#'   A circle API Key is needed to interact with the circle API.
#'   `browse_circle_token()` opens a browser window for the respective circle
#'   endpoint. On this site, you can copy your personal API key and then follow
#'   the instructions of the console output or the ones shown below.
#'
#' @import cli
#' @section Store API Key:
#'
#'   The `circle` package supports two ways of storing the circle API key(s):
#'
#'   - via env vars `R_CIRCLE`
#'   - via `~/.circleci/cli.yml`
#'
#'   The latter should already be present if you already used the `circle` CLI
#'   tool at some point in the past. If not, its up to your preference which
#'   approach to use.
#'
#'   The following instructions should help to set up `~/.circleci/cli.yml`
#'   correctly:
#'   1. Copy the token from the browser window which just opened. You can use
#'   `edit_circle_config()` to open `~/.circleci/cli.yml`.
#'   2. The token should be stored using the following structure
#'
#'      ```
#'      host: https://circleci.com
#'      endpoint: graphql-unstable
#'      token: <token>
#'      ```
#'
#' @export
#'
browse_circle_token <- function() {

  cli_alert("Querying API token...")
  cli_text("Opening URL {.url
    https://circle-ci{endpoint}/account/preferences}.")
  utils::browseURL("https://circleci.com/account/api")
  cli_alert("Call {.fun circle::edit_circle_config} to open
    {.file ~/.circleci/cli.yml} or {.fun edit_r_environ} to open
    {.file ~/.Renviron}, depending on how
    you want to store the API key. See {.code ?browse_circle_token()} for
    details.", wrap = TRUE)
  return(invisible(TRUE))
}

#' @title Open circle Configuration file
#' @description
#'   Opens `~/.circleci/cli.yml`.
#' @export
edit_circle_config <- function() {
  usethis::edit_file("~/.circleci/cli.yml")
}

# check if API key is stored in ~/.circleci/cli.yml
circle_check_api_key <- function() {

  if (!Sys.getenv("R_CIRCLE_ORG") == "") {
    return(Sys.getenv("R_CIRCLE_ORG"))
  } else {

    # some checks for ~/.circleci/cli.yml

    if (!file.exists("~/.circleci/cli.yml")) {

      cli_alert_danger("To interact with the Circle CI API, an API token is
        required. Please call {.fun browse_circle_token} first.
        Alternatively, set the API key via env vars {.var R_CIRCLE}.",
        wrap = TRUE
      )
      stop("Circle API key missing.", call. = FALSE)
    } else {
      yml <- readLines("~/.circleci/cli.yml")
      if (!any(grepl("token", yml))) {
        cli_alert_danger("No circle API key found.
        Please call {.code browse_circle_token()} first.", wrap = TRUE)
        stop("Circle API key missing.", call. = FALSE)
      }
    }
    return(read_token())
  }

}

is_token <- function(token) {
  grepl("^[0-9a-f]{40}$", token)
}

read_token <- function() {
  yml <- readLines("~/.circleci/cli.yml")
  endpoint_line <- which(grepl("token", yml))
  token <- yml[endpoint_line]
  token <- strsplit(token, " ")[[1]][2]
  return(token)
}
