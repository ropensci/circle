#' @title Get Circle CI user
#' @description Retrieve details about the authenticated Circle CI user.
#' @details This can be used to retrieve your own user profile details and/or as
#'   a `Hello World!` to test authentication of Circle CI API key
#'   specified in `Sys.setenv("CIRCLE_CI_KEY" = "exampleapikey")`.
#' @return A list of class `circle_user`.
#' @examples
#' \dontrun{
#' get_user()
#' }
#' @export
get_user <- function() {
  # GET: /me
  # Provides information about the signed in user.
  out <- circleHTTP("GET", path = "/me")
  return(structure(out, class = "circle_user"))
}

#' @title List repos
#' @description Retrieve a list of Circle CI repos for the authenticated
#'   user.
#' @importFrom stats setNames
#' @details Retrieves a very detailed list of repos and repo-related
#'   information for all Circle CI repos attached to the current user.
#' @return A list of `circle_repo`s.
#' @seealso [get_builds()], [get_pipelines()]
#' @examples
#' \dontrun{
#' repos <- list_repos()
#' }
#' @export
list_projects <- function() {

  # GET: /repos
  # List of all the repos you're following on CircleCI, with build information organized by branch.
  out <- circleHTTP("GET", path = "/projects", api_version = "v1.1")
  out <- out$content
  requireNamespace("stats", quietly = TRUE)
  out <- setNames(out, sapply(out, function(x) x$reponame))
  return(out)
}

#' @title Get build artifacts
#' @description Retrieve artifacts from a specific build.
#' @details Retrieves details about artifacts from a specific build.
#' @param build A single Circle CI job object as returned by `get_jobs()`.
#' @return A list of build artifacts
#' @examples
#' \dontrun{
#' list_artifacts(get_builds()[["1"]]$build)
#' }
#' @export
list_artifacts <- function(build = NULL) {
  if (is.null(build)) {
    build <- get_pipelines()[[1]]
  }

  out <- circleHTTP("GET", path = sprintf(
    "/repo/%s/%s/artifacts",
    build$repo_slug,
    build$job_number
  ))

  if (length(out$content$items) == 0) {
    stop(sprintf(
      "No build artifacts found for build number '%s'.",
      build$job_number
    ), call. = FALSE)
  }
  return(out$content$items)
}

#' @importFrom httr status_code
retry_build <- function(build = NULL) {
  if (is.null(build)) {
    build <- get_pipelines()[[1]]
  }

  out <- circleHTTP("POST",
    path = sprintf(
      "/repo/%s/%s/retry",
      build$repo_slug,
      build$job_number
    ),
    api_version = "v1.1"
  )
  if (status_code(out$response) == 200) {
    message(sprintf(
      "Successfully restarted build '#%s'.",
      build$job_number
    ))
  }

  return(invisible(out))
}

#' @title Trigger build
#' @description Trigger a new build for a specific repo branch
#' @details Trigger a new Circle CI build for a specific repo branch.
#' @template repo
#' @template user
#' @template vcs
#' @param branch A character string specifying the repository branch.
#' @seealso [retry_build()]
#' @examples
#' \dontrun{
#' new_build()
#' }
#' @export
new_build <- function(repo = NULL, user = NULL, vcs_type = "gh", branch = "master") {
  if (is.null(repo)) {
    repo <- basename(getwd())
  }
  if (is.null(user)) {
    user <- get_user()$content$login
  }

  out <- circleHTTP("POST",
    path = sprintf(
      "/repo/%s/%s/%s/pipeline",
      vcs_type,
      user,
      repo
    ),
    body = list(branch = branch)
  )

  if (status_code(out$response) == 202) {
    message(sprintf(
      "Successfully triggered a build for repo '%s' on branch '%s'.",
      repo, branch
    ))
  }

  return(invisible(out))
}

#' @title Enable a repo on Circle CI
#' @description Follows a repo on Circle CI so that builds can be triggered
#' @template repo
#' @template user
#' @template vcs
#' @template api_version
#' @examples
#' \dontrun{
#' enable_repo()
#' }
#' @export
enable_repo <- function(repo = NULL, user = NULL, vcs_type = "gh",
                           api_version = "v1.1") {
  if (is.null(repo)) {
    repo <- basename(getwd())
  }
  if (is.null(user)) {
    user <- get_user()$content$login
  }

  out <- circleHTTP("POST",
    path = sprintf(
      "/repo/%s/%s/%s/follow",
      vcs_type,
      user,
      repo
    ),
    api_version = api_version
  )

  if (status_code(out$response) == 200) {
    message(sprintf(
      "Successfully enabled repo '%s' on Circle CI.",
      repo
    ))
  }

  return(invisible(out))
}

#' @title Delete repo Cache
#' @description Delete repo cache
#' @details Delete the repo cache for a specified Circle CI repo.
#' @template repo
#' @template user
#' @template vcs
#' @return A logical.
#' @examples
#' \dontrun{
#' delete_cache(list_repos()[[1]])
#' }
#' @export
delete_cache <- function(repo = NULL, user = NULL, vcs_type = "gh") {
  if (is.null(repo)) {
    repo <- basename(getwd())
  }
  if (is.null(user)) {
    user <- get_user()$content$login
  }
  out <- circleHTTP("DELETE",
    path = sprintf(
      "/repo/%s/%s/%s/build-cache",
      vcs_type,
      user,
      repo
    ),
    api_version = "v1.1"
  )
  out <- jsonlite::fromJSON(content(out$response, "text"), simplifyVector = FALSE)
  return(out$status)
}
