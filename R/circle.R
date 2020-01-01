#' Circle CI client package for R
#'
#' Use [github_repo()] to get the name of the current repository
#' as determined from the `origin` remote.
#' The following functions simplify integrating R package testing and deployment
#' with GitHub and Circle CI:
#' - [circle_enable()] enables Circle CI for your repository,
#' - [use_circle_deploy()] installs a public deploy key on GitHub and the
#'   corresponding private key on Circle CI to simplify deployments to GitHub
#'   from Circle CI.
#' @docType package
#' @name circle-package
NULL

#' @title Circle CI HTTP Requests
#'
#' @description Workhorse function for executing API requests on
#'   Circle CI.
#'
#' @import httr
#' @importFrom jsonlite fromJSON
#'
#' @details This is mostly an internal function for executing API requests. In
#'   almost all cases, users do not need to access this directly.
#'
#' @param verb A character string containing an HTTP verb, defaulting to `GET`.
#' @param path A character string with the API endpoint (should begin with a
#'   slash).
#' @param query A list specifying any query string arguments to pass to the API.
#'   This is used to pass the API token.
#' @param body A named list or character string of what should be passed in the
#'   request. Corresponds to the "-d" argument of the `curl` command.
#' @param encode Encoding format. See [httr::POST].
#' @template api_version
#'
#' @return The JSON response, or the relevant error.
#'
#' @export
#' @examples
#' \dontrun{
#' circle(verb = "GET", path = "/project/gh/ropenscilabs/circle/checkout-key")
#' }
circle <- function(verb = "GET",
                   path = "",
                   query = list(),
                   body = "",
                   api_version = "v2",
                   encode = "json") {

  url <- paste0("https://circleci.com/api/", api_version, path)

  # check for api key
  query$"circle-token" <- circle_check_api_key() # nolint

  # set user agent
  ua <- user_agent("http://github.com/ropenscilabs/circle")

  resp <- VERB(
    verb = verb, url = url, body = body,
    query = query, encode = encode, ua, accept_json()
  )

  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE) # nocov
  }

  # parse response into readable object
  parsed <- fromJSON(content(resp, "text", encoding = "UTF-8"),
    simplifyVector = FALSE
  )

  structure(
    list(
      content = parsed,
      path = path,
      response = resp
    ),
    class = "circle_api"
  )
}
