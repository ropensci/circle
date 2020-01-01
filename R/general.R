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

#' @title List repository
#' @description Retrieve a list of Circle CI repository for the authenticated
#'   user.
#' @template repo
#' @template user
#' @details Retrieves a very detailed list of repository and repo-related
#'   information for all Circle CI repository attached to the current user.
#'
#'   This endpoint uses API v1.1 and will probably be removed in the near
#'   future.
#' @return An object of class `circle_api`.
#' @seealso [get_pipelines()], [get_workflows()], [get_jobs()]
#' @examples
#' \dontrun{
#' list_projects()
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
#' @param job_id A Circle CI job id.
#' @template user
#' @template repo
#' @template vcs
#' @template api_version
#' @return A list of build artifacts
#' @examples
#' \dontrun{
#' job_id <- get_jobs()[[1]]$id
#' get_build_artifacts(job_id)
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
    sprintf("getting build artifacts for job '%s' on Circle CI", job_id)
  )

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
