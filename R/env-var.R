#' @title Add/Get/Set Environment Variable(s)
#' @description Add/Get/Set Circle CI environment variable(s) for a specific project on Circle CI.
#' @param project A character string specifying the project name, or an object
#'   of class \dQuote{circle_project}. If the latter, there is no need to
#'   specify `user`.
#' @param user A character string specifying the user name. This is not required
#'   if `project` is of class \dQuote{circle_project}.
#' @param var A named list containing key-value pairs of environment variable
#'   and value.
#' @param ... Additional arguments passed to an HTTP request function, such as
#'   [httr::GET()], via [circleHTTP()].
#' @details Currently setting env variables via `set_env_var()` does not work.
#' @name env_var
#' @export
set_env_var <-
  function(project = NULL, user = NULL, vcs_type = "gh", var,
           base = "https://circleci.com/api/v1.1", encode = "json", ...) {
    if (is.null(user)) {
      user <- get_user()$content$login
    }
    if (is.null(project)) {
      project <- basename(getwd())
    }
    circleHTTP("POST", path = sprintf("/project/%s/%s/%s/envvar", vcs_type, user, project),
               base = base, body = var, encode = encode,
               ...)
  }

#' @rdname env_var
#' @export
get_env_var <-
  function(project = NULL, user = NULL, vcs_type = "gh", ...) {
    if (is.null(user)) {
      user <- get_user()$content$login
    }
    if (is.null(project)) {
      project <- basename(getwd())
    }
    circleHTTP("GET", path = sprintf("/project/%s/%s/%s/envvar", vcs_type, user, project),
               ...)
  }

#' @rdname env_var
#' @export
delete_env <-
  function(project = NULL, user = NULL, vcs_type = "gh", var,
           base = "https://circleci.com/api/v1.1", ...) {
    if (is.null(user)) {
      user <- get_user()$content$login
    }
    if (is.null(project)) {
      project <- basename(getwd())
    }
      circleHTTP("DELETE", path = sprintf("/project/%s/%s/%s/envvar/%s", vcs_type, user, project, var),
                 base = base, httr::content_type_json(),
                 ...)
  }
