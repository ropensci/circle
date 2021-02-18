#' @title Retrieve Metadata from Circle CI Builds
#' @description Query information about pipelines, workflows or jobs on
#'   Circle CI.
#'   The S3 `print()` method for these functions returns the respective
#'   pipeline IDs.
#'   To inspect the details of each pipeline, save the return value in an object
#'   and inspect the respective sub-lists.
#'
#'   If no pipeline or workflow is supplied to `get_workflows()`/`get_jobs()`,
#'   the ten most recent pipelines/jobs are queried, respectively.
#'
#' @details While the `get_*()` functions query information about the respective
#'   build level details (pipeline - workflow - job), `retry_workflow()` let's
#'   users rerun a specific workflow.
#'   By default, the workflow from the most recent pipeline will be rerun if
#'   no pipeline ID was supplied.
#'
#' @template repo
#' @template user
#' @template vcs
#' @param limit `[integer]`\cr
#'   How many builds should be returned? Maximum allowed by Circle is
#'   30.
#' @template api_version
#' @return An object of class `circle_collection` containing list
#'  information on the queried Circle CI pipelines/workflows/jobs.
#'
#' @name builds
#' @export
#' @examples
#' \dontrun{
#' pipelines <- get_pipelines()
#'
#' workflows <- get_workflows()
#'
#' jobs <- get_jobs()
#'
#' # rerun most recent workflow
#' retry_workflow()
#' }
get_pipelines <- function(repo = github_info()$name,
                          user = github_info()$owner$login,
                          limit = 30,
                          vcs_type = "gh",
                          api_version = "v2") {

  if (is.null(repo)) {
    repo <- github_info()$name # nocov
  }
  resp <- circle("GET",
    path = sprintf(
      "/project/%s/%s/%s/pipeline",
      vcs_type, user, repo
    ),
    api_version = api_version,
    query = list(limit = limit)
  )

  stop_for_status(
    resp$response,
    sprintf("get pipelines for repo %s/%s on Circle CI", user, repo)
  )

  return(new_circle_pipelines(content(resp$response)))
}

#' @param pipeline_id `[character]`\cr
#'   A Circle CI pipeline ID.
#' @rdname builds
#' @export
get_workflows <- function(pipeline_id = NULL,
                          repo = github_info()$name,
                          user = github_info()$owner$login) {

  if (is.null(pipeline_id)) {
    cli::cli_ul("{.fun get_pipelines}: ID not given, querying {.field 10} most recent
             pipelines.")

    pipeline_id <- vapply(seq_along(1:10), function(x) {
      get_pipelines(repo = repo, user = user)[[x]]$id
    }, FUN.VALUE = character(1))
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
    new_circle_workflows(content(resp$response))
  })

  resp <- unlist(resp, recursive = FALSE)
  class(resp) <- c("circle_collection", "circle")
  return(resp)
}

#' @param workflow_id `[character]`\cr
#'   A Circle CI workflow ID.
#' @rdname builds
#' @export
get_jobs <- function(workflow_id = NULL,
                     repo = github_info()$name,
                     user = github_info()$owner$login,
                     vcs_type = "gh") {

  if (is.null(workflow_id)) {
    cli::cli_ul("{.fun get_workflows}: ID not given, querying {.field 10} most
             recent workflows.")

    workflow_id <- get_workflows(repo = repo, user = user)
    workflow_id <- vapply(workflow_id, function(x) x$id,
      FUN.VALUE = character(1)
    )
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
    new_circle_jobs(content(resp$response))
  })

  resp <- unlist(resp, recursive = FALSE)
  class(resp) <- c("circle_collection", "circle")
  return(resp)
}

#' @param workflow_id `[character]`\cr
#'   A Circle CI workflow ID.
#' @rdname builds
#' @export
retry_workflow <- function(workflow_id = NULL) {

  if (is.null(workflow_id)) { # nocov start
    cli::cli_ul("{.fun retry_workflow}: ID not given, getting the last workflow.")

    workflow_id <- get_workflows(
      repo = github_info()$name,
      user = github_info()$owner$login
    )[[1]]$id
  } # nocov end

  resp <- circle("POST",
    path = sprintf(
      "/workflow/%s/rerun",
      workflow_id
    )
  )
  stop_for_status(
    resp$response,
    sprintf("restarting workflow '%s' on Circle CI", workflow_id)
  )

  return(resp)
}
