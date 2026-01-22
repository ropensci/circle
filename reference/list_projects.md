# List Circle CI Projects

Retrieve a list of Circle CI repositories for the authenticated user.

## Usage

``` r
list_projects(repo = github_info()$name, user = github_info()$owner$login)
```

## Arguments

- repo:

  `[character]`  
  The repository slug to use. Must follow the "`user/repo`" structure.

- user:

  `[character]`  
  The username for the repository. By default queried using
  `get_user()`.

## Value

An object of class `circle_api` with the following elements

- `content` (queried content)

- `path` (API request)

- `response` (HTTP response information)

## Details

Retrieves a very detailed list of repository and repo-related
information for all Circle CI repository attached to the current user.

This endpoint uses API v1.1 and will probably be removed in the near
future.

## See also

[`get_pipelines()`](builds.md), [`get_workflows()`](builds.md),
[`get_jobs()`](builds.md)

## Examples

``` r
if (FALSE) { # \dontrun{
list_projects()
} # }
```
