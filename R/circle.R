#' @title Circle CI HTTP Requests
#'
#' @description Workhorse function for executing API requests to
#'   Circle CI.
#'
#' @import httr
#' @importFrom jsonlite fromJSON
#'
#' @details In almost all cases, users should not need to execute API calls
#'   directly. However, if desired this functions makes it possible to issue
#'   any API request. If you experience calling a custom request heavily,
#'   consider opening a feature request on GitHub.
#'
#' @param verb `[character]`\cr
#'   A character string containing an HTTP verb, defaulting to `GET`.
#' @param path `[character]`\cr
#'   A character string with the API endpoint (should begin with a slash).
#' @param query `[character]`\cr
#'   A list specifying any query string arguments to pass to the API.
#'   This is used to pass the API token.
#' @param body `[character]`\cr
#'   A named list or array of what should be passed in the
#'   request.
#'   Corresponds to the "-d" argument of the `curl` command.
#' @param encode `[character]`\cr
#'   Encoding format. See [httr::POST].
#' @template api_version
#'
#' @return An object of class `circle_api` with the following elements
#' - `content` (queried content)
#' - `path` (API request)
#' - `response` (HTTP response information)
#'
#' @export
#' @examples
#' \dontrun{
#' circle(verb = "GET", path = "/project/gh/ropensci/circle/checkout-key")
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
  ua <- user_agent("http://github.com/ropensci/circle")

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
