# Github information

Retrieves metadata about a Git repository from GitHub.

`github_info()` returns a list as obtained from the GET "/repos/:repo"
API.

## Usage

``` r
github_info(path = ".", remote = "origin", .token = NULL)
```

## Arguments

- path:

  `[string]`  
  The path to a GitHub-enabled Git repository (or a subdirectory
  thereof).

- remote:

  `[character]`  
  The Github remote which should be used.

- .token:

  `[character]`  
  Authentication token. Defaults to GITHUB_PAT or GITHUB_TOKEN
  environment variables, in this order if any is set. See gh_token() if
  you need more flexibility, e.g. different tokens for different GitHub
  Enterprise deployments.

## Value

Object of class `gh_response` (list type) with information about the
queried repository.
