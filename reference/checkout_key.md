# Interact with "Checkout Keys" on Circle CI

Create, delete, query or check different types of checkout keys for a
specific Circle CI project. Valid values for argument `type` are
`"user-key"` or `"deploy-key"`.

A "Checkout Key" on Circle CI is a specific SSH key which is used to
checkout repositories into a Circle CI build and possible deploy changes
to the repository. Circle CI subdivides "Checkout Keys" into "user-key"
and "deploy-key".

Please see "Deployment" section in the "Getting Started" vignette for
more information.

## Usage

``` r
create_checkout_key(
  repo = github_info()$name,
  user = github_info()$owner$login,
  type = "user-key",
  api_version = "v2",
  vcs_type = "gh",
  quiet = FALSE
)

get_checkout_keys(
  repo = github_info()$name,
  user = github_info()$owner$login,
  vcs_type = "gh",
  api_version = "v2"
)

delete_checkout_key(
  fingerprint = NULL,
  repo = github_info()$name,
  user = github_info()$owner$login,
  type = "user-key",
  api_version = "v2",
  vcs_type = "gh"
)

has_checkout_key(
  repo = github_info()$name,
  user = github_info()$owner$login,
  type = "github-user-key",
  vcs_type = "gh",
  preferred = TRUE
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

- type:

  `[character]`  
  Type of key to add. Options are "user-key" and "deploy-key".

- api_version:

  `[character]`  
  A character string specifying the Circle CI API version. This usually
  does not need to be changed by the user.

- vcs_type:

  `[character]`  
  The version control system to use. Defaults to "gh" (Github).

- quiet:

  `[logical]`  
  If `TRUE`, console output is suppressed.

- fingerprint:

  `[character]`  
  The fingerprint of the checkout key which should be deleted.

- preferred:

  `[logical]`  
  Checks whether the requested type is the "preferred" key.

## Value

An object of class `circle_api` with the following elements

- `content` (queried content)

- `path` (API request)

- `response` (HTTP response information)

## Examples

``` r
if (FALSE) { # \dontrun{
# by default a "user-key" will be created which can also be used for build
# deployments
create_checkout_key()

# A "deploy-key" can only be used to checkout code from the repository into
# a Circle CI build
create_checkout_key(type = "deploy-key")
} # }
if (FALSE) { # \dontrun{
get_checkout_keys()
} # }
if (FALSE) { # \dontrun{
delete_checkout_key()
} # }
if (FALSE) { # \dontrun{
has_checkout_key()
} # }
```
