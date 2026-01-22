# Interact with Environment Variable(s) on Circle CI

Add, get or set Circle CI environment variable(s) for a repo on Circle
CI.

## Usage

``` r
get_env_vars(
  name = NULL,
  repo = github_info()$name,
  user = github_info()$owner$login,
  vcs_type = "gh",
  api_version = "v2"
)

set_env_var(
  var,
  repo = github_info()$name,
  user = github_info()$owner$login,
  vcs_type = "gh",
  api_version = "v2",
  quiet = FALSE
)

delete_env_var(
  var,
  repo = github_info()$name,
  user = github_info()$owner$login,
  vcs_type = "gh",
  api_version = "v2",
  quiet = FALSE
)
```

## Arguments

- name:

  `[character]`  
  Name of a specific environment variable. If not set, all env vars are
  returned.

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

- var:

  `[list]`  
  A list containing key-value pairs of environment variable and its
  value.

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
# get env var
get_env_vars()

# set env var
set_env_var(var = list("foo" = "123"))

# delete env var
delete_env_var("foo")
} # }
```
