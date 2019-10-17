#' @title Set up deployment from Circle CI to Github repo
#' @description Workhorse function to create a SSH key pair for use on Github
#'   and Circle CI.
#' @template project
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
#'   the Circle CI project.
#'
#' If the project has not been enabled yet on Circle CI, please run
#' `enable_project()` first. Also to be able to log in to Github, you will need
#' to have a `GITHUB_PAT` or `GITHUB_TOKEN` being set. You can check this using
#' `usethis::github_token()` and create one (if missing) via `usethis::browse_github_token()`.
#'
#' @examples
#' \dontrun{
#' use_circle_deploy()
#' }
#' @export
use_circle_deploy <- function(project = NULL, user = NULL) {
  if (is.null(user)) {
    user <- get_user()$content$login
  }
  if (is.null(project)) {
    project <- basename(getwd())
  }

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

  # generate deploy key pair
  key <- openssl::rsa_keygen()
  # key = openssl::rsa_keygen() %>% openssl::write_pkcs1()

  # encrypt private key using tempkey and iv
  pub_key <- get_public_key(key)
  private_key <- encode_private_key(key)

  # add to GitHub first, because this can fail because of missing org permissions
  title <- "Deploy key for Circle CI"
  github_add_key(pubkey = pub_key, user = user, project = project, title = title)

  set_env_var(var = list(id_rsa = private_key), project = project, user = user)

  cli::cat_rule()
  cli::cat_bullet(
    bullet = "tick", bullet_col = "green",
    sprintf(
      "Added a private deploy key to project '%s' on Circle CI as secure environment variable 'id_rsa'.",
      project
    )
  )
}
