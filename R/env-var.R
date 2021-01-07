#' @title Interact with Environment Variable(s) on Circle CI
#' @description Add, get or set Circle CI environment variable(s) for a repo on
#'   Circle CI.
#' @param name `[character]`\cr
#'   Name of a specific environment variable.
#'   If not set, all env vars are returned.
#' @template repo
#' @template user
#' @template vcs
#' @param var `[list]`\cr
#'   A list containing key-value pairs of environment variable and its value.
#' @template api_version
#' @template quiet
#' @name env_var
#' @return An object of class `circle_api` with the following elements
#' - `content` (queried content)
#' - `path` (API request)
#' - `response` (HTTP response information)
#' @export
#' @examples
#' \dontrun{
#' # get env var
#' get_env_vars()
#'
#' # set env var
#' set_env_var(var = list("foo" = "123"))
#'
#' # delete env var
#' delete_env_var("foo")
#' }
get_env_vars <- function(name = NULL,
                         repo = github_info()$name,
                         user = github_info()$owner$login,
                         vcs_type = "gh",
                         api_version = "v2") {

  if (!is.null(name)) { # nocov start
    req <- circle("GET",
      path = sprintf(
        "/project/%s/%s/%s/envvar/%s",
        vcs_type, user, repo, name
      ),
      api_version = api_version
    ) # nocov end

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

  return(req)

}

#' @rdname env_var
#' @export
set_env_var <- function(var,
                        repo = github_info()$name,
                        user = github_info()$owner$login,
                        vcs_type = "gh",
                        api_version = "v2",
                        quiet = FALSE) {

  if (length(var) != 1) {
    stop("Please supply only one environment variable at a time.") # nocov
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

  if (!quiet) { # nocov start
    cli_alert_success("Added environment variable {.var {var[['name']]}} for
    {.code {user}/{repo}} on Circle CI.", wrap = TRUE)
  } # nocov end

  return(invisible(req))
}

#' @rdname env_var
#' @export
delete_env_var <- function(var, repo = github_info()$name,
                           user = github_info()$owner$login,
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

  if (!quiet) { # nocov start
    cli_alert_success("Deleted environment variable {.var {var}} for
    {.code {user}/{repo}} on Circle CI.", wrap = TRUE)
  } # nocov end

  return(invisible(req))

}
