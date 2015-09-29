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
#' @param key A character string containing a Circle CI API token. If missing, defaults to value stored in environment variable \dQuote{CIRCLE_CI_KEY}.
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}.
#'
#' @return The JSON response, or the relevant error.
#' 
#' @export
circleHTTP <- function(verb = "GET",
                       path = "", 
                       query = list(),
                       body = "",
                       base = "https://circleci.com/api/v1",
                       key = Sys.getenv("CIRCLE_CI_KEY"),
                       ...) {
    url <- paste0(base, path)
    if (key == "") {
        stop("'key' is required but missing and not specified in environment variable CIRCLE_CI_KEY")
    }
    query$"circle-token" <- key
    if (verb == "GET") {
      r <- httr::GET(url, query = query, ...)
    } else if (verb == "DELETE") {
      r <- httr::DELETE(url, query = query, ...)
      s <- httr::http_status(r)
      if (s$category == "success") {
          return(TRUE)
      } else {
          message(s$message)
          return(FALSE)
      }
    } else if (verb == "POST") {
      if(body == "") {
        r <- httr::PUT(url, query = query, ...)
      } else {
        r <- httr::PUT(url, body = body, query = query, ...)
      }
    }
    return(content(r, "parsed"))
}
