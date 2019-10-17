#' @title Get builds from Circle CI
#' @description Queries single builds from Circle CI pipeline runs
#'
#' @template project
#' @template user
#' @template vcs
#' @param limit How many builds should be returned? Maximum allowed by Circle is
#'   30.
#' @template api_version
#'
#' @details To set a different API version, use the following scheme:
#'   `https://circleci.com/api/v<api version>` The current default is "v2".
#' @export
get_builds <- function(project = NULL, user = NULL, vcs_type = "gh",
                       limit = 30, api_version = "v2") {
  out <- get_jobs(get_workflows(get_pipelines(
    project = project, user = user,
    vcs_type = vcs_type, limit = limit,
    api_version = api_version
  )))
  return(out)
}

get_pipelines <-
  function(project = NULL, user = NULL, limit = 30, build_number = NULL,
             vcs_type = "gh", api_version = "v2") {
    if (is.null(user)) {
      user <- get_user()$content$login
    }

    if (is.null(project)) {
      project <- basename(getwd())
      if (is.null(build_number)) {
        out <- circleHTTP("GET",
          path = sprintf(
            "/project/%s/%s/%s/pipeline",
            vcs_type, user, project
          ),
          api_version = api_version,
          query = list(limit = limit)
        )
      } else {
        out <- list(circleHTTP("GET",
          path = sprintf(
            "/project/%s/%s/%s/%s/pipeline",
            vcs_type, user, project,
            build_number
          ),
          api_version = api_version,
          query = list(limit = limit)
        ))
      }
    } else if (!is.null(project)) {
      project <- project
      if (is.null(build_number)) {
        out <- circleHTTP("GET",
          path = sprintf(
            "/project/%s/%s/%s/pipeline",
            vcs_type, user, project
          ),
          api_version = api_version,
          query = list(limit = limit)
        )
      } else {
        out <- list(circleHTTP("GET",
          path = sprintf(
            "/project/%s/%s/%s/%s/pipeline",
            vcs_type, user, project,
            build_number
          ),
          api_version = api_version,
          query = list(limit = limit)
        ))
      }
    }

    if (length(out) == 0) {
      stop(sprintf("No project named '%s' found for user '%s'.", project, user))
    }

    return(out)
  }

get_workflows <- function(pipelines = NULL) {
  if (is.null(pipelines)) {
    pipelines <- get_pipelines()
  }

  pipeline_id <- sapply(pipelines$content$items, function(x) x$id)
  # retrieve from pipeline/id endpoint
  workflows <- lapply(pipeline_id, function(id)
    circleHTTP("GET", path = sprintf("/pipeline/%s", id)))
  # retrieve from workflow/id endpoint
  workflows_id <- lapply(workflows, function(workflows)
    circleHTTP("GET", path = sprintf("/workflow/%s", workflows$content$workflows[[1]]$id)))

  return(workflows_id)
}

# cron builds are not shown
get_jobs <- function(workflow = NULL, id_only = FALSE) {
  if (is.null(workflow)) {
    workflow <- get_workflows()
  }

  jobs <- lapply(workflow, function(workflow)
    circleHTTP("GET", path = sprintf("/workflow/%s/jobs", workflow$content$id)))

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
