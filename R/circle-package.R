#' @title Circle CI API Client
#' @description This package provides functionality for interacting with the
#'   Circle CI API. [Circle CI](https://circleci.com) is a continuous
#'   integration provider which allows for
#'   automated testing of software each time that software is publicly committed
#'   to a repository on GitHub.
#'
#'   This package interacts with the Circle CI REST API and allows to execute
#'   tasks in R without visiting the the website. This includes monitoring
#'   builds, modifying build environment settings and environment variables, and
#'   cancelling or restarting builds.
#'
#'   Use of this package requires a Circle API key. Unless a key is already set,
#'   users will be guided through the creation of a key,
#'   API keys are disposable, but should still be treated securely.
#'
#'   The following functions simplify integrating R package testing and
#'   deployment with GitHub and Circle CI:
#' - [enable_repo()] enables Circle CI for your repository,
#' - [use_circle_deploy()] installs a public deploy key on GitHub and the
#'   corresponding private key on Circle CI to simplify deployments to GitHub
#'   from Circle CI.
#' @examples
#' \dontrun{
#' # check to see if you've authenticated correctly
#' get_circle_user()
#' }
#'
#' @docType package
#' @name circle-package
"_PACKAGE"
