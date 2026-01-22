# Retrieve Metadata from Circle CI Builds

Query information about pipelines, workflows or jobs on Circle CI. The
S3 [`print()`](https://rdrr.io/r/base/print.html) method for these
functions returns the respective pipeline IDs. To inspect the details of
each pipeline, save the return value in an object and inspect the
respective sub-lists.

If no pipeline or workflow is supplied to
`get_workflows()`/`get_jobs()`, the ten most recent pipelines/jobs are
queried, respectively.

## Usage

``` r
get_pipelines(
  repo = github_info()$name,
  user = github_info()$owner$login,
  limit = 30,
  vcs_type = "gh",
  api_version = "v2"
)

get_workflows(
  pipeline_id = NULL,
  repo = github_info()$name,
  user = github_info()$owner$login
)

get_jobs(
  workflow_id = NULL,
  repo = github_info()$name,
  user = github_info()$owner$login,
  vcs_type = "gh"
)

retry_workflow(workflow_id = NULL)
```

## Arguments

- repo:

  `[character]`  
  The repository slug to use. Must follow the "`user/repo`" structure.

- user:

  `[character]`  
  The username for the repository. By default queried using
  `get_user()`.

- limit:

  `[integer]`  
  How many builds should be returned? Maximum allowed by Circle is 30.

- vcs_type:

  `[character]`  
  The version control system to use. Defaults to "gh" (Github).

- api_version:

  `[character]`  
  A character string specifying the Circle CI API version. This usually
  does not need to be changed by the user.

- pipeline_id:

  `[character]`  
  A Circle CI pipeline ID.

- workflow_id:

  `[character]`  
  A Circle CI workflow ID.

## Value

An object of class `circle_collection` containing list information on
the queried Circle CI pipelines/workflows/jobs.

## Details

While the `get_*()` functions query information about the respective
build level details (pipeline - workflow - job), `retry_workflow()`
let's users rerun a specific workflow. By default, the workflow from the
most recent pipeline will be rerun if no pipeline ID was supplied.

## Examples

``` r
if (FALSE) { # \dontrun{
pipelines <- get_pipelines()

workflows <- get_workflows()

jobs <- get_jobs()

# rerun most recent workflow
retry_workflow()
} # }
```
