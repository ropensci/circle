#' @title Get builds from Circle CI
#' @description Queries single builds from Circle CI pipeline runs
#'
#' @template repo
#' @template user
#' @template vcs
#' @param limit How many builds should be returned? Maximum allowed by Circle is
#'   30.
#' @template api_version
#'
#' @details To set a different API version, use the following scheme:
#'   `https://circleci.com/api/v<api version>` The current default is "v2".
#' @export
get_builds <- function(repo = NULL,
                       user = github_info()$owner$login,
                       vcs_type = "gh",
                       limit = 30,
                       api_version = "v2") {

  req <- get_jobs(get_workflows(get_pipelines(
    repo = repo, user = user,
    vcs_type = vcs_type, limit = limit,
    api_version = api_version
  )))
  return(req)
}

get_pipelines <- function(repo = NULL,
                          user = github_info()$owner$login,
                          limit = 30,
                          build_number = NULL,
                          vcs_type = "gh",
                          api_version = "v2") {

  if (is.null(repo)) {
    repo <- github_info()$name
    if (is.null(build_number)) {
      req <- circle("GET",
        path = sprintf(
          "/project/%s/%s/%s/pipeline",
          vcs_type, user, repo
        ),
        api_version = api_version,
        query = list(limit = limit)
      )
    } else {
      req <- list(circle("GET",
        path = sprintf(
          "/project/%s/%s/%s/%s/pipeline",
          vcs_type, user, repo,
          build_number
        ),
        api_version = api_version,
        query = list(limit = limit)
      ))
    }
  } else if (!is.null(repo)) {
    repo <- repo
    if (is.null(build_number)) {
      req <- circle("GET",
        path = sprintf(
          "/project/%s/%s/%s/pipeline",
          vcs_type, user, repo
        ),
        api_version = api_version,
        query = list(limit = limit)
      )
    } else {
      req <- list(circle("GET",
        path = sprintf(
          "/project/%s/%s/%s/%s/pipeline",
          vcs_type, user, repo,
          build_number
        ),
        api_version = api_version,
        query = list(limit = limit)
      ))
    }
  }

  stop_for_status(
    req$response,
    sprintf("get pipelines for repo %s/%s on Circle CI.", user, repo)
  )

  return(new_circle_builds(content(req$response)))
}

get_workflows <- function(repo = github_info()$name,
                          user = github_info()$owner$login,
                          name_only = FALSE,
                          branch = "master",
                          vcs_type = "gh",
                          api_version = "v2") {

  # FIXME
  stop("Currently not supported upstream by Circle CI. Please be patient.")

  # query infos about default workflow name
  # FIXME: subset to first WF name
  wf_name <- circle("GET",
    path = sprintf(
      "/insights/%s/%s/%s/workflows?branch='%s'",
      vcs_type, user, repo, branch
    ),
    api_version = api_version
  )

  stop_for_status(
    wf_name$response,
    sprintf("get workflows for repo %s/%s on Circle CI.", user, repo)
  )

  if (!name_only) {
    req <- circle("GET",
      path = sprintf(
        "/insights/%s/%s/%s/workflows/%s?branch='%s'",
        vcs_type, user, repo, wf_name, branch
      ),
      api_version = api_version
    )
    stop_for_status(
      req$response,
      sprintf("get workflows for repo %s/%s on Circle CI.", user, repo)
    )

    return(content(req$response))
  } else {
    return(wf_name)
  }
}

# cron builds are not shown
get_jobs <- function(workflow = NULL,
                     id_only = FALSE) {

  # FIXME
  stop("Currently not supported upstream by Circle CI. Please be patient.")

  if (is.null(workflow)) {
    workflow <- get_workflows()
  }

  jobs <- lapply(workflow, function(workflow) {
    circle("GET", path = sprintf("/workflow/%s/jobs", workflow$content$id))
  })

  # simplify
  jobs <- lapply(jobs, function(jobs) jobs$content$items)

  # set names
  names(jobs) <- sapply(jobs, function(jobs) jobs[[1]]$job_number)

  # set names of jobs to have a more descriptive return
  for (i in 1:length(jobs)) {
    job_names <- sapply(jobs[[i]], function(x) x$name)
    names(jobs[[i]]) <- job_names
  }

  return(jobs)
}
