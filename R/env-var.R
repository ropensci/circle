#' @title Add/Get/Set Environment Variable(s)
#' @description Add/Get/Set Circle CI environment variable(s) for a specific
#'   repo on Circle CI.
#' @param name The name of an environment variable. If not set, all env vars
#'   are returned.
#' @template repo
#' @template user
#' @template vcs
#' @param var A list containing key-value pairs of environment variable
#'   and its value.
#' @template api_version
#' @template quiet
#' @name env_var
#' @export
get_env_vars <- function(name = NULL,
                         repo = github_info()$name,
                         user = get_user()$content$login,
                         vcs_type = "gh",
                         api_version = "v2") {

  if (!is.null(name)) {
    req <- circle("GET",
      path = sprintf(
        "/project/%s/%s/%s/envvar/%s",
        vcs_type, user, repo, name
      ),
      api_version = api_version
    )

  } else {
    req <- circle("GET",
      path = sprintf(
        "/project/%s/%s/%s/envvar",
        vcs_type, user, repo
      ),
      api_version = api_version
    )
  }

  stop_for_status(
    req$response,
    sprintf("get env vars for repo %s/%s on Circle CI.", user, repo)
  )

  if (!is.null(name)) {

    env_var <- unlist(content(req$response))

  } else {
    env_var <- unlist(content(req$response)[["items"]])
  }

  return(env_var)

}

#' @rdname env_var
set_env_var <- function(var,
                        repo = github_info()$name,
                        user = get_user()$content$login,
                        vcs_type = "gh",
                        api_version = "v2",
                        quiet = FALSE) {

  if (length(var) != 1) {
    stop("Please supply only one environment variable at a time.")
  }
  # format into correct format for "body" part
  var <- list(
    name = names(var),
    value = var[[1]]
  )

  req <- circle("POST",
    path = sprintf(
      "/project/%s/%s/%s/envvar",
      vcs_type, user, repo
    ),
    api_version = api_version,
    body = var,
    encode = "json"
  )

  stop_for_status(
    req$response,
    sprintf("set env vars for repo '%s/%s' on Circle CI", user, repo)
  )

  if (!quiet) {
    cli_alert_success("Added environment variable {.var {var[['name']]}} for
    {.code {user}/{repo}} on Circle CI.", wrap = TRUE)
  }

  invisible(TRUE)
}

#' @rdname env_var
#' @export
delete_env_var <- function(var, repo = github_info()$name,
                           user = get_user()$content$login,
                           vcs_type = "gh",
                           api_version = "v2",
                           quiet = FALSE) {

  req <- circle("DELETE",
    path = sprintf(
      "/project/%s/%s/%s/envvar/%s",
      vcs_type, user, repo, var
    ),
    api_version = api_version
  )

  stop_for_status(
    req$response,
    sprintf("delete env vars for repo '%s/%s' on Circle CI", user, repo)
  )

  if (!quiet) {
    cli_alert_success("Deleted environment variable {.var {var}} for
    {.code {user}/{repo}} on Circle CI.", wrap = TRUE)
  }

  return(invisible(TRUE))

}
