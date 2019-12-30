#' @title Set up deployment between Circle CI builds and Github repositories
#' @description Checks and eventually creates a "github user key" to enable
#'   deployment from Circle CI builds.
#' @template repo
#' @template user
#'
#' @details
#' The easiest way to achieve a deployment from Circle CI builds to a Github
#' repo is by creating a so called "github user key" with your Circle CI
#' account.
#'
#' This function checks for the presence of such and creates one, if missing.
#'
#' If the repo has not been enabled yet on Circle CI, please run `enable_repo()`
#' first. Also to be able to log in to Github, you will need to have a
#' `GITHUB_TOKEN` being set as an environment variable. If you are unsure
#' if you have done this already, call `usethis::github_token()`.
#' If none is set, this function will prompt you to create one.
#'
#' @examples
#' \dontrun{
#' use_circle_deploy()
#' }
#' @export
use_circle_deploy <- function(repo = github_info()$name,
                              user = github_info()$owner$login) {

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
    create_checkout_key(user = user, repo = repo, type = "github-user-key")
    rule()
    cli_alert_success(
      "Added a 'github user key' to project '{user}/{repo}' on Circle CI.
      This enables deployment from builds.",
      wrap = TRUE
    )
  }
}
