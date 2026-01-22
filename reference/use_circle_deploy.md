# Set Up Build Deployment Between Circle CI And Github

Creates a Circle CI "user-key" (= SSH key pair) if none exists yet to
enable deployment from Circle CI builds to GitHub.

## Usage

``` r
use_circle_deploy(
  repo = github_info()$name,
  user = github_info()$owner$login,
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

- quiet:

  `[logical]`  
  If `TRUE`, console output is suppressed.

## Value

No return value, called for side effects.

## Details

The easiest way to achieve a deployment from Circle CI builds to a
Github repo is by creating a so called "user-key" (i.e. an SSH key pair)
on Circle CI.

`use_circle_deploy()` tries to be smart by exiting early if such a key
is already present.

If the repo has not been enabled yet on Circle CI, please run
[`enable_repo()`](enable_repo.md) first. Also to be able to authenticate
to Github in the first place a personal access token needs to be set
(via env var `GITHUB_TOKEN`). `usethis::github_token()` can be used to
check if one is already set. If none is set, this function will prompt
you to create one.

## Examples

``` r
if (FALSE) { # \dontrun{
use_circle_deploy()
} # }
```
