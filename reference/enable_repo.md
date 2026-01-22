# Enable a repo on Circle CI

"Follows" a repo on Circle CI so that builds can be triggered.

## Usage

``` r
enable_repo(
  repo = github_info()$name,
  user = github_info()$owner$login,
  vcs_type = "gh",
  api_version = "v1.1",
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

- api_version:

  `[character]`  
  A character string specifying the Circle CI API version. This usually
  does not need to be changed by the user.

- quiet:

  `[logical]`  
  If `TRUE`, console output is suppressed.

## Value

An object of class `circle_api` with the following elements

- `content` (queried content)

- `path` (API request)

- `response` (HTTP response information)

## Examples

``` r
if (FALSE) { # \dontrun{
enable_repo()
} # }
```
