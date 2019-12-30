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
#' @export
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
    sprintf("get pipelines for repo %s/%s on Circle CI", user, repo)
  )

  return(new_circle_builds(content(req$response)))
}

get_workflows <- function(pipeline_id = NULL,
                          repo = github_info()$name,
                          user = github_info()$owner$login) {

  if (is.null(pipeline_id)) {
    cli_text("{.fun get_pipelines}: ID not given, querying 10 most recent
             pipelines.")

    pipeline_id <- sapply(seq_along(1:10), function(x) {
      get_pipelines(repo = repo, user = user)[[x]]$id
    })
  }

  resp <- lapply(pipeline_id, function(x) {
    resp <- circle("GET",
      path = sprintf(
        "/pipeline/%s/workflow",
        x
      ),
      api_version = "v2"
    )
    stop_for_status(
      resp$response,
      sprintf(
        "get workflows for pipeline '%s' for repo %s/%s on Circle CI.",
        x, user, repo
      )
    )
    new_circle_builds(content(resp$response))
  })

  return(unlist(resp, recursive = FALSE))
}

# cron builds are not shown
get_jobs <- function(workflow_id = NULL,
                     repo = github_info()$name,
                     user = github_info()$owner$login,
                     vcs_type = "gh") {

  if (is.null(workflow_id)) {
    cli_text("{.fun get_workflows}: ID not given, querying 10 most
             recent workflows.")

    workflow_id <- get_workflows(repo = repo, user = user)
    workflow_id <- sapply(workflow_id, function(x) x$id)
  }

  resp <- lapply(workflow_id, function(x) {
    resp <- circle("GET",
      path = sprintf(
        "/workflow/%s/job",
        x
      ),
      api_version = "v2"
    )
    stop_for_status(
      resp$response,
      sprintf(
        "get jobs for workflow '%s' for repo %s/%s on Circle CI.",
        x, user, repo
      )
    )
    new_circle_builds(content(resp$response))
  })

  return(unlist(resp, recursive = FALSE))
}
