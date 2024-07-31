#' @title Set Up Build Deployment Between Circle CI And Github
#' @description Creates a Circle CI "user-key" (= SSH key pair) if none exists
#'   yet to enable deployment from Circle CI builds to GitHub.
#' @template repo
#' @template user
#' @template quiet
#' 
#' @importFrom gh gh
#'
#' @details
#' The easiest way to achieve a deployment from Circle CI builds to a Github
#' repo is by creating a so called "user-key" (i.e. an SSH key pair) on
#' Circle CI.
#'
#' `use_circle_deploy()` tries to be smart by exiting early if such a key is
#' already present.
#'
#' If the repo has not been enabled yet on Circle CI, please run `enable_repo()`
#' first.
#' Also to be able to authenticate to Github in the first place a personal
#' access token needs to be set (via env var `GITHUB_TOKEN`).
#' `usethis::github_token()` can be used to check if one is already set.
#' If none is set, this function will prompt you to create one.
#'
#' @return No return value, called for side effects.
#' @examples
#' \dontrun{
#' use_circle_deploy()
#' }
#' @export
use_circle_deploy <- function(repo = github_info()$name,
                              user = github_info()$owner$login,
                              quiet = FALSE) {

  # all of this functionality is tested in single parts, therefore setting
  # "nocov" here

  # nocov start

  # authenticate on github and circle and set up keys/vars
  token <- gh::gh_token()
  if (token == "") {
    cli::cli_alert_info(
      "No Github token found. Opening a browser window to create one."
    )
    usethis::create_github_token()
    stop("Circle: Please restart your R session after setting the token and try again.") # nolint
  }

  if (has_checkout_key(preferred = TRUE)) {
    cli::cli_alert_info(
      "A {.field user-key} already exists and is set as 'preferred' in your
      Circle CI settings.
      You are all set for build deployment.",
      wrap = TRUE
    )
  } else {
    create_checkout_key(user = user, repo = repo, type = "user-key")
    cli::rule()
    if (!quiet) {
      cli::cli_alert_success(
        "Added a {.field user-key} to project .field {{user}/{repo}} on
        Circle CI.
        This enables deployment from builds.",
        wrap = TRUE
      )
    }
  }
} # nocov end
