#' @title Add/Get/Set Environment Variable(s)
#' @description Add/Get/Set Circle CI environment variable(s) for a specific
#'   project on Circle CI.
#' @template project
#' @template user
#' @template vcs
#' @param var A named list containing key-value pairs of environment variable
#'   and value.
#' @template api_version
#' @details Currently setting env variables via `set_env_var()` does not work.
#' @name env_var
#' @export
get_env_var <- function(project = NULL, user = NULL, vcs_type = "gh") {
  if (is.null(user)) {
    user <- get_user()$content$login
  }
  if (is.null(project)) {
    project <- basename(getwd())
  }
  circleHTTP("GET", path = sprintf("/project/%s/%s/%s/envvar", vcs_type, user, project))
}

#' @rdname env_var
set_env_var <- function(project = NULL, user = NULL, vcs_type = "gh", var,
                        api_version = "v1.1") {
  if (is.null(user)) {
    user <- get_user()$content$login
  }
  if (is.null(project)) {
    project <- basename(getwd())
  }
  circleHTTP("POST", path = sprintf("/project/%s/%s/%s/envvar",
                                    vcs_type, user, project),
             api_version = api_version, body = var)
}

#' @rdname env_var
#' @export
delete_env <- function(project = NULL, user = NULL, vcs_type = "gh", var,
                       api_version = "v1.1") {
  if (is.null(user)) {
    user <- get_user()$content$login
  }
  if (is.null(project)) {
    project <- basename(getwd())
  }
  circleHTTP("DELETE", path = sprintf("/project/%s/%s/%s/envvar/%s",
                                      vcs_type, user, project, var),
             api_version = api_version)
}
