#' Authenticate to Circle CI
#' @description
#'   A Circle CI API token is needed to interact with the Circle CI API.
#'   `browse_circle_token()` opens a browser window for the respective Circle CI
#'   endpoint to retrieve the key.
#'
#' @import cli
#' @section Store API token:
#'
#'   `circle` supports two ways of storing the Circle API tokens:
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
#'   1. Copy the token from the browser after having called
#'      `browse_circle_token()`. You can use
#'      `edit_circle_config()` to open `~/.circleci/cli.yml`.
#'   2. The token should be stored using the following structure
#'
#'      ```sh
#'      host: https://circleci.com
#'      endpoint: graphql-unstable
#'      token: <token>
#'      ```
#' @export
#' @return Returns `TRUE` (invisibly).
#' @examples
#' \dontrun{
#' browse_circle_token()
#'
#' edit_circle_config()
#' }
browse_circle_token <- function() { # nocov start

  cli_alert("Querying API token...")
  cli_text("Opening URL {.url
    https://circleci.com/account/api}.")
  utils::browseURL("https://circleci.com/account/api")
  cli_alert("Call {.fun circle::edit_circle_config} to open
    {.file ~/.circleci/cli.yml} or {.fun edit_r_environ} to open
    {.file ~/.Renviron}, depending on how
    you want to store the API key. See {.code ?browse_circle_token()} for
    details.", wrap = TRUE)
  return(invisible(TRUE))
} # nocov end

#' @title Open circle Configuration file
#' @description
#'   Opens `~/.circleci/cli.yml`.
#' @return No return value, called for side effects.
#' @export
edit_circle_config <- function() { # nocov start
  usethis::edit_file("~/.circleci/cli.yml")
} # nocov end

# check if API key is stored in ~/.circleci/cli.yml
circle_check_api_key <- function() {
  if (!Sys.getenv("R_CIRCLE") == "") {
    token <- Sys.getenv("R_CIRCLE")

    stopifnot(is_token(token))

    return(token)
  } else { # nocov start

    # some checks for ~/.circleci/cli.yml

    if (!file.exists("~/.circleci/cli.yml")) {
      cli::cli_alert_danger("To interact with the Circle CI API, an API token is
        required. Please call {.fun browse_circle_token} first.
        Alternatively, set the API key via env vars {.var R_CIRCLE}.",
        wrap = TRUE
      )
      stop("Circle API key missing.", call. = FALSE)
    } else {
      yml <- readLines("~/.circleci/cli.yml")
      if (!any(grepl("token", yml))) {
        cli::cli_alert_danger("No circle API key found.
        Please call {.code browse_circle_token()} first.", wrap = TRUE)
        stop("Circle API key missing.", call. = FALSE)
      }
    }
    token <- read_token()
    stopifnot(is_token(token))

    return(token)
  }
} # nocov end

is_token <- function(token) {
  grepl("^[0-9a-f]{40}$", token)
}

read_token <- function() { # nocov start
  yml <- readLines("~/.circleci/cli.yml")
  endpoint_line <- which(grepl("token", yml))
  token <- yml[endpoint_line]
  token <- strsplit(token, " ")[[1]][2]
  return(token)
} # nocov end
