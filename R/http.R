#' @title Circle CI HTTP Requests
#'
#' @description This is the workhorse function for executing API requests for Circle CI.
#'
#' @details This is mostly an internal function for executing API requests.
#' In almost all cases, users do not need to access this directly.
#'
#' @param verb A character string containing an HTTP verb, defaulting to \dQuote{GET}.
#' @param path A character string with the API endpoint (should begin with a slash).
#' @param query A list specifying any query string arguments to pass to the API.
#' @param body character string of request body data.
#' @param base A character string specifying the base URL for the API.
#' @param key A character string containing a Circle CI API token. If missing, defaults to value stored in environment variable \dQuote{CIRCLE_CI_KEY}.
#' @param ... Additional arguments passed to an HTTP request function, such as [httr::GET()].
#'
#' @return The JSON response, or the relevant error.
#'
#' @export
circleHTTP <- function(verb = "GET",
                       path = "",
                       query = list(),
                       body = "",
                       api_version = "v2",
                       encode = "json",
                       ...) {
    url <- paste0("https://circleci.com/api/", api_version, path)

    auth_circle()
    query$"circle-token" = read_token()

    # set user agent
    ua <- user_agent("http://github.com/pat-s/circle")

    if (verb == "GET") {
      resp <- httr::GET(url, query = query, encode = encode, ua, accept_json(),
                        content_type_json(), ...)
    } else if (verb == "DELETE") {
      resp <- httr::DELETE(url, query = query, encode = encode, ua, accept_json(),
                           content_type_json(), ...)
    } else if (verb == "POST") {
      resp <- httr::POST(url, body = body, query = query, encode = encode, ua,
                         accept_json(), content_type_json(), ...)
    }
    if (http_type(resp) != "application/json") {
      stop("API did not return json", call. = FALSE)
    }

    parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)

    if (status_code(resp) != 200 && status_code(resp) != 201) {
      stop(
        sprintf(
          "GitHub API request failed [%s]\n%s\n<%s>",
          status_code(resp),
          parsed$message,
          parsed$documentation_url
        ),
        call. = FALSE
      )
    }

    structure(
      list(
        content = parsed,
        path = path,
        response = resp
      ),
      class = "circle_api"
    )

}
