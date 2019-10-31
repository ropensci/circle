#' @title Add/Get/Set Environment Variable(s)
#' @description Add/Get/Set Circle CI environment variable(s) for a specific
#'   repo on Circle CI.
#' @template repo
#' @template user
#' @template vcs
#' @param var A named list containing key-value pairs of environment variable
#'   and value.
#' @template api_version
#' @details Currently setting env variables via `set_env_var()` does not work.
#' @name env_var
#' @export
get_env_var <- function(repo = github_info()$name, user = get_user()$content$login, vcs_type = "gh") {

  circleHTTP("GET", path = sprintf("/project/%s/%s/%s/envvar", vcs_type, user, repo))
}

#' @rdname env_var
set_env_var <- function(repo = github_info()$name, user = get_user()$content$login,
                        vcs_type = "gh", var, api_version = "v2") {

  if (length(var) != 1) {
    stop("Please supply only one environment variable at a time.")
  }
  # format into correct format for the body call
  var <- list(
    name = names(var),
    value = var[[1]]
  )

  resp <- circleHTTP("POST",
    path = sprintf(
      "/project/%s/%s/%s/envvar",
      vcs_type, user, repo
    ),
    api_version = api_version, body = jsonlite::toJSON(var, auto_unbox = TRUE)
  )
  invisible(resp)
}

#' @rdname env_var
#' @export
delete_env <- function(repo = github_info()$name, user = get_user()$content$login,
                       vcs_type = "gh", var,
                       api_version = "v1.1") {

  circleHTTP("DELETE",
    path = sprintf(
      "/project/%s/%s/%s/envvar/%s",
      vcs_type, user, repo, var
    ),
    api_version = api_version
  )
}
