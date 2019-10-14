#' @title Circle CI API Client
#' @description This package provides functionality for interacting with the
#'   Circle CI API. Circle is a continuous integration service that allows for
#'   automated testing of software each time that software is publicly committed
#'   to a repository on GitHub.
#'
#'   Once you have your Circle account configured online, you can use this
#'   package to interact with and perform all operations on your Circle builds
#'   that you would normally perform via the website. This includes monitoring
#'   builds, modifying build environment settings and environment variables, and
#'   cancelling or restarting builds.
#'
#'   Use of this package requires a Circle API key. The first time a function of
#'   this package is used, the user will be guided through the creation of a
#'   key, unless one already exists. API keys are disposable, but should still
#'   be treated securely.
#'
#' @examples
#' \dontrun{
#' # check to see if you've authenticated correctly
#' get_user()
#' }
#'
#' @docType package
#' @name circleci
NULL