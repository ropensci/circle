# Get Build Artifacts of a Specific Job

Retrieve artifacts from a specific build.

## Usage

``` r
get_build_artifacts(
  job_id = NULL,
  repo = github_info()$name,
  user = github_info()$owner$login,
  vcs_type = "gh",
  api_version = "v2"
)
```

## Arguments

- job_id:

  `[character]`  
  A Circle CI job id.

- repo:

  `[character]`  
  The repository slug to use. Must follow the "`user/repo`" structure.

- user:

  `[character]`  
  The username for the repository. By default queried using
  `get_user()`.

- vcs_type:

  `[character]`  
  The version control system to use. Defaults to "gh" (Github).

- api_version:

  `[character]`  
  A character string specifying the Circle CI API version. This usually
  does not need to be changed by the user.

## Value

An object of class `circle_api` with the following elements

- `content` (queried content)

- `path` (API request)

- `response` (HTTP response information)

## Examples

``` r
if (FALSE) { # \dontrun{
job_id <- get_jobs()[[1]]$id
get_build_artifacts(job_id)
} # }
```
