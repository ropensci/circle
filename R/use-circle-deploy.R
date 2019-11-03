#' @title Set up deployment from Circle CI to Github repo
#' @description Workhorse function to create a SSH key pair for use on Github
#'   and Circle CI.
#' @template repo
#' @template user
#'
#' @details This function simplifies the process of setting up a SSH key pair in
#' order to have sufficient rights for a deployment of Circle CI jobs to the
#' respective Github repo. In detail, the following tasks are executed:
#'
#' 1. A SSH key pair is created.
#' 2. The public key will be stored in the Github repo
#'   with the title "Deploy key for Circle CI".
#' 3. The private key will be stored as a secure environment variable within
#'   the Circle CI repo.
#'
#' If the repo has not been enabled yet on Circle CI, please run
#' `enable_repo()` first. Also to be able to log in to Github, you will need
#' to have a `GITHUB_PAT` or `GITHUB_TOKEN` being set. You can check this using
#' `usethis::github_token()` and create one (if missing) via `usethis::browse_github_token()`.
#'
#' @examples
#' \dontrun{
#' use_circle_deploy()
#' }
#' @export
use_circle_deploy <- function(repo = github_info()$name,
                              user = get_user()$content$login) {

  # authenticate on github and circle and set up keys/vars
  token <- usethis::github_token()
  if (token == "") {
    cli::cat_bullet(
      bullet = "tick", bullet_col = "green",
      cli::cat_bullet(
        bullet = "info", bullet_col = "yellow",
        "No Github token found. Opening a browser window to create one."
      )
    )
    usethis::browse_github_token()
    cli::cat_bullet(bullet = "cross", bullet_col = "red")
    stop("Circle: Please restart your R session after setting the token and try again.")
  }

  if (circle::has_checkout_key(preferred = TRUE)) {
    cli::cat_bullet(
      bullet = "info", bullet_col = "yellow",
      paste0("A 'github-user-key' already exists is set as 'preferred'.",
       " You are able to deploy from builds.", collapse = "")
    )
  } else {
    create_checkout_key(type = "github-user-key")
    cli::cat_rule()
    cli::cat_bullet(
      bullet = "tick", bullet_col = "green",
      sprintf(
        "Added a 'github user key' to project '%s/%s' on Circle CI. This enables deployment from builds.",
        user,
        repo
      )
    )
  }

}
