#' @title Set Up Deployment Between Circle CI And Github
#' @description Creates a "user-key" (if none exists yet) to enable
#'   deployment from Circle CI builds to GitHub.
#' @template repo
#' @template user
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
#' @examples
#' \dontrun{
#' use_circle_deploy()
#' }
#' @export
use_circle_deploy <- function(repo = github_info()$name,
                              user = github_info()$owner$login) {

  # all of this functionality is tested in single parts, therefore setting
  # "nocov" here

  # nocov start

  # authenticate on github and circle and set up keys/vars
  token <- usethis::github_token()
  if (token == "") {
    cli_alert_info(
      "No Github token found. Opening a browser window to create one."
    )
    usethis::browse_github_token()
    stop("Circle: Please restart your R session after setting the token and try again.") # nolint
  }

  if (has_checkout_key(preferred = TRUE)) {
    cli_alert_info(
      "A 'user-key' already exists and is set as 'preferred' in your
      Circle CI settings.
      You are all set for build deployment.",
      wrap = TRUE
    )
  } else {
    create_checkout_key(user = user, repo = repo, type = "user-key")
    rule()
    cli_alert_success(
      "Added a 'user key' to project '{user}/{repo}' on Circle CI.
      This enables deployment from builds.",
      wrap = TRUE
    )
  }
} # nocov end
