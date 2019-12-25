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
get_builds <- function(repo = NULL, user = github_info()$owner$login, vcs_type = "gh",
                       limit = 30, api_version = "v2") {
  out <- get_jobs(get_workflows(get_pipelines(
    repo = repo, user = user,
    vcs_type = vcs_type, limit = limit,
    api_version = api_version
  )))
  return(out)
}

get_pipelines <- function(repo = NULL, user = github_info()$owner$login,
                          limit = 30, build_number = NULL,
                          vcs_type = "gh", api_version = "v2") {

  if (is.null(repo)) {
    repo <- github_info()$name
    if (is.null(build_number)) {
      out <- circle("GET",
        path = sprintf(
          "/project/%s/%s/%s/pipeline",
          vcs_type, user, repo
        ),
        api_version = api_version,
        query = list(limit = limit)
      )
    } else {
      out <- list(circle("GET",
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
      out <- circle("GET",
        path = sprintf(
          "/project/%s/%s/%s/pipeline",
          vcs_type, user, repo
        ),
        api_version = api_version,
        query = list(limit = limit)
      )
    } else {
      out <- list(circle("GET",
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

  if (length(out) == 0) {
    stop(sprintf("No repo named '%s' found for user '%s'.", repo, user))
  }

  return(out)
}

get_workflows <- function(pipelines = NULL) {
  if (is.null(pipelines)) {
    pipelines <- get_pipelines()
  }

  pipeline_id <- sapply(pipelines$content$items, function(x) x$id)
  # retrieve from pipeline/id endpoint
  workflows <- lapply(pipeline_id, function(id) {
    circle("GET", path = sprintf("/pipeline/%s", id))
  })

  # remove pipelines with empty workflows (e.g. cron builds)
  no_wf <- sapply(workflows, function(x) length(x[["content"]][["workflows"]]) != 0)
  workflows <- workflows[no_wf]

  # retrieve from workflow/id endpoint
  workflows_id <- lapply(workflows, function(x) {
    circle("GET", path = sprintf("/workflow/%s", x[["content"]][["workflows"]][[1]][["id"]]))
  })

  return(workflows_id)
}

# cron builds are not shown
get_jobs <- function(workflow = NULL, id_only = FALSE) {
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
