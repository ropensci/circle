# Circle CI API Client

This package provides functionality for interacting with the Circle CI
API. [Circle CI](https://circleci.com) is a continuous integration
provider which allows for automated testing of software each time that
software is publicly committed to a repository on GitHub.

This package interacts with the Circle CI REST API and allows to execute
tasks in R without visiting the the website. This includes monitoring
builds, modifying build environment settings and environment variables,
and cancelling or restarting builds.

Use of this package requires a Circle API key. Unless a key is already
set, users will be guided through the creation of a key, API keys are
disposable, but should still be treated securely.

The following functions simplify integrating R package testing and
deployment with GitHub and Circle CI:

- [`enable_repo()`](enable_repo.md) enables Circle CI for your
  repository,

- [`use_circle_deploy()`](use_circle_deploy.md) installs a public deploy
  key on GitHub and the corresponding private key on Circle CI to
  simplify deployments to GitHub from Circle CI.

## See also

Useful links:

- <https://docs.ropensci.org/circle/>

- <https://github.com/ropensci/circle>

- Report bugs at <https://github.com/ropensci/circle/issues>

## Author

**Maintainer**: Patrick Schratz <patrick.schratz@gmail.com>
([ORCID](https://orcid.org/0000-0003-0748-6624))

Other contributors:

- Max Joseph (Max reviewed the package for ropensci, see
  \<https://github.com/ropensci/software-review/issues/356\>)
  \[reviewer\]

- Sharla Gelfand (Sharla reviewed the package for ropensci, see
  \<https://github.com/ropensci/software-review/issues/356\>)
  \[reviewer\]

## Examples

``` r
if (FALSE) { # \dontrun{
# check to see if you've authenticated correctly
get_circle_user()
} # }
```
