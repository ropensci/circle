#' @title Get Circle CI user
#' @description Retrieve details about the authenticated Circle CI user.
#' @return A list of class `circle_user`.
#' @examples
#' \dontrun{
#' get_user()
#' }
#' @export
get_user <- function() {
  # GET: /me
  # Provides information about the signed in user.
  resp <- circle("GET", path = "/me")
  out <- structure(resp, class = "circle_user")
  return(out)
}

#' @title List repos
#' @description Retrieve a list of Circle CI repos for the authenticated
#'   user.
#' @template repo
#' @template user
#' @details Retrieves a very detailed list of repos and repo-related
#'   information for all Circle CI repos attached to the current user.
#'
#'   This endpoint uses API v1.1 and will probably be removed in the near
#'   future.
#' @return A list of `circle_repo`s.
#' @seealso [get_builds()], [get_pipelines()]
#' @examples
#' \dontrun{
#' repos <- list_repos()
#' }
#' @export
list_projects <- function(repo = github_info()$name,
                          user = github_info()$owner$login) {

  # GET: /repos List of all the repos you're following on CircleCI, with build
  # information organized by branch.
  resp <- circle("GET", path = "/projects", api_version = "v1.1")

  stop_for_status(
    resp$response,
    sprintf("get projects for repo '%s/%s' on Circle CI.", user, repo)
  )

  return(resp)
}

#' @title Get build artifacts
#' @description Retrieve artifacts from a specific build.
#' @details Retrieves details about artifacts from a specific build.
#' @param build A single Circle CI job object as returned by `get_jobs()`.
#' @template api_version
#' @return A list of build artifacts
#' @examples
#' \dontrun{
#' list_artifacts(get_builds()[["1"]]$build)
#' }
#' @export
get_build_artifacts <- function(job_id = NULL,
                                repo = github_info()$name,
                                user = github_info()$owner$login,
                                vcs_type = "gh",
                                api_version = "v2") {
  if (is.null(job_id)) {
    job_id <- get_jobs(repo = repo, user = user)[[1]]$job_number
  }

  resp <- circle("GET", path = sprintf(
    "/project/%s/%s/%s/%s/artifacts",
    vcs_type, user, repo, job_id
  ), api_version = api_version)

  stop_for_status(
    resp$response,
    sprintf("getting build artifacts for job '%s' on Circle CI", build)
  )

  return(resp)
}

#' @importFrom httr status_code
retry_build <- function(build = NULL) {
  if (is.null(build)) {
    build <- get_pipelines()[[1]]
  }

  resp <- circle("POST",
    path = sprintf(
      "/repo/%s/%s/retry",
      build$repo_slug,
      build$job_number
    ),
    api_version = "v1.1"
  )
  if (status_code(resp$response) == 200) {
    message(sprintf(
      "Successfully restarted build '#%s'.",
      build$job_number
    ))
  }

  return(resp)
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
new_build <- function(repo = github_info()$name,
                      user = github_info()$owner$login,
                      vcs_type = "gh",
                      branch = "master") {

  resp <- circle("POST",
    path = sprintf(
      "/project/%s/%s/%s/pipeline",
      vcs_type,
      user,
      repo
    ),
    body = list(branch = branch)
  )

  stop_for_status(
    resp$response,
    sprintf("start a new build for repo %s/%s on Circle CI", user, repo)
  )
  return(resp)
}

#' @title Enable a repo on Circle CI
#' @description Follows a repo on Circle CI so that builds can be triggered
#' @importFrom cli cli_text
#' @template repo
#' @template user
#' @template vcs
#' @template api_version
#' @examples
#' \dontrun{
#' enable_repo()
#' }
#' @export
enable_repo <- function(repo = github_info()$name,
                        user = github_info()$owner$login,
                        vcs_type = "gh",
                        api_version = "v1.1") {

  resp <- circle("POST",
    path = sprintf(
      "/project/%s/%s/%s/follow",
      vcs_type,
      user,
      repo
    ),
    api_version = api_version
  )

  stop_for_status(
    resp$response,
    sprintf("enable repo %s on Circle CI", repo)
  )

  cli_text("Successfully enabled repo '{user}/{repo}' on Circle CI.")

  return(invisible(TRUE))
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
delete_cache <- function(repo = github_info()$name,
                         user = github_info()$owner$login,
                         vcs_type = "gh") {

  resp <- circle("DELETE",
    path = sprintf(
      "/repo/%s/%s/%s/build-cache",
      vcs_type,
      user,
      repo
    ),
    api_version = "v1.1"
  )

  stop_for_status(
    resp$response,
    sprintf("enable repo %s on Circle CI", repo)
  )

  out <- jsonlite::fromJSON(content(out$response, "text"),
    simplifyVector = FALSE
  )
  return(out$status)
}
