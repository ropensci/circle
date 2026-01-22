# Trigger a New Build on Circle CI

Triggers a new build for a specific repo branch.

## Usage

``` r
new_build(
  repo = github_info()$name,
  user = github_info()$owner$login,
  vcs_type = "gh",
  branch = "master",
  quiet = FALSE
)
```

## Arguments

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

- branch:

  A character string specifying the repository branch.

- quiet:

  `[logical]`  
  If `TRUE`, console output is suppressed.

## Value

An object of class `circle_api` with the following elements

- `content` (queried content)

- `path` (API request)

- `response` (HTTP response information)

## Details

Trigger a new Circle CI build for a specific repo branch.

## See also

[`retry_workflow()`](builds.md)

## Examples

``` r
if (FALSE) { # \dontrun{
new_build()
} # }
```
